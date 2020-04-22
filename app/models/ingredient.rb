class Ingredient < ApplicationRecord
  has_many :ingredient_recipes, dependent: false
  has_many :recipes, through: :ingredient_recipes

  validates :name, presence: true, uniqueness: true

  # Parses an ingredient line into an ingredient hash
  # e.g. '100g of flour' -> {name: 'flour', amount: 100, amount_unit: 'g'}
  def self.parse(ingredient_line)
    ingredient_line = replace_leading_unicode_vulgar_fraction(ingredient_line)

    amount, amount_unit, name = ingredient_line
                                .downcase
                                .match(%r{
                                      ^
                                      ((?:half |
                                          \d*
                                          (?:\/|\.?)
                                          \d+))?
                                      \s*
                                      (?:(ml|l|pints?|g|tsp|teaspoons?|tbsp|tablespoons?)\s)?
                                      (?:of\s)?
                                      (?:an|a \s)?
                                      (.*)
                                      $
                                    }x)
                                .to_a[1..]

    amount = 0.5 if amount == 'half'
    amount = Fractional.new(amount || '').to_f

    amount, amount_unit = parse_amount_unit(amount, amount_unit)

    ingredient_hash(name, amount, amount_unit)
  end
end

def ingredient_hash(name, amount, amount_unit)
  {
    name: name,
    amount: amount,
    amount_unit: amount_unit
  }
end

def parse_amount_unit(amount, amount_unit)
  case amount_unit
  when 'l'
    amount *= 1000
    amount_unit = 'ml'
  when 'tablespoon', 'tablespoons'
    amount_unit = 'tbsp'
  when 'teaspoon', 'teaspoons'
    amount_unit = 'tsp'
  when 'pint', 'pints'
    amount *= 568.261
    amount_unit = 'ml'
  when nil
    if amount.zero?
      amount = amount_unit = nil
    else
      amount_unit = 'whole'
    end
  end

  [amount, amount_unit]
end

def replace_leading_unicode_vulgar_fraction(input_str)
  vulgar_fraction_regex = /(¼|½|¾|⅐|⅑|⅒|⅓|⅔|⅕|⅖|⅗|⅘|⅙|⅚|⅛|⅜|⅝|⅞)/
  vulgar_fraction = input_str.match(vulgar_fraction_regex)

  if vulgar_fraction
    input_str.sub(vulgar_fraction.to_s, unicode_vulgar_fraction_to_s(vulgar_fraction.to_s))
  else
    input_str
  end
end

def unicode_vulgar_fraction_to_s(vulgar_fraction_str)
  {
    '¼' => '1/4',
    '½' => '1/2',
    '¾' => '3/4',
    '⅐' => '1/7',
    '⅑' => '1/9',
    '⅒' => '1/10',
    '⅓' => '1/3',
    '⅔' => '2/3',
    '⅕' => '1/5',
    '⅖' => '2/5',
    '⅗' => '3/5',
    '⅘' => '4/5',
    '⅙' => '1/6',
    '⅚' => '5/6',
    '⅛' => '1/8',
    '⅜' => '3/8',
    '⅝' => '5/8',
    '⅞' => '7/8'
  }[vulgar_fraction_str]
end
