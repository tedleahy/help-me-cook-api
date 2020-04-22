class Ingredient < ApplicationRecord
  has_many :ingredient_recipes, dependent: false
  has_many :recipes, through: :ingredient_recipes

  validates :name, presence: true, uniqueness: true

  # Parses an ingredient line into an ingredient hash
  # e.g. '100g of flour' -> {name: 'flour', amount: 100, amount_unit: 'g'}
  def self.parse(ingredient_line)
    amount, amount_unit, *, name = ingredient_line
                                   .downcase
                                   .match(%r{
                                      ^
                                      (\d*/?\d+)?
                                      \s*
                                      (ml|g|tsp|tbsp)?
                                      \s*
                                      (of\s)?
                                      (.*)
                                      $
                                    }x)
                                   .to_a[1..]

    amount = Fractional.new(amount || '').to_f
    amount, amount_unit = parse_amount_unit(amount, amount_unit)

    ingredient_hash(name, amount, amount_unit)
  end
end

def parse_amount_unit(amount, amount_unit)
  return [amount, amount_unit] unless amount_unit.nil?

  if amount.zero?
    amount = amount_unit = nil
  else
    amount_unit = 'whole'
  end

  [amount, amount_unit]
end

def ingredient_hash(name, amount, amount_unit)
  {
    name: name,
    amount: amount,
    amount_unit: amount_unit
  }
end
