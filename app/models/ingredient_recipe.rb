class IngredientRecipe < ApplicationRecord
  MEASUREMENT_UNITS = %w[ml g tbsp tsp whole].freeze

  belongs_to :ingredient
  belongs_to :recipe

  def ingredient_details
    { id: ingredient.id,
      name: ingredient.name,
      amount: amount,
      amount_unit: amount_unit }
  end
end
