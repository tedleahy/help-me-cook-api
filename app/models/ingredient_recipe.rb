class IngredientRecipe < ApplicationRecord
  MEASUREMENT_UNITS = %w[ml grams tbsp tsp whole].freeze

  belongs_to :ingredient
  belongs_to :recipe

  def ingredient_name_and_amount
    { name: ingredient.name,
      amount: amount,
      amount_unit: amount_unit }
  end
end
