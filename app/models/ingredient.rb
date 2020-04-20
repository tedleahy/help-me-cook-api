class Ingredient < ApplicationRecord
  has_many :ingredient_recipes, dependent: false
  has_many :recipes, through: :ingredient_recipes

  validates :name, presence: true, uniqueness: true

  # Parses an ingredient line into an ingredient hash
  # e.g. '100g of flour' -> {name: 'flour', amount: 100, amount_unit: 'g'}
  def self.parse(ingredient_line)
    amount, amount_unit, name = ingredient_line
                                .downcase
                                .match(/^(\d*)\s*(ml|g|tsp|tbsp)?\s*o?f?\s?(.*)$/).to_a[1..]
    amount = amount.to_f

    if amount.zero? && !amount_unit
      amount = amount_unit = nil
    elsif amount && !amount_unit
      amount_unit = 'whole'
    end

    {
      name: name,
      amount: amount,
      amount_unit: amount_unit
    }
  end
end
