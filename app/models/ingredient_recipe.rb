class IngredientRecipe < ApplicationRecord
  MEASUREMENT_UNITS = %w[ml grams tbsp tsp whole].freeze

  belongs_to :ingredient
  belongs_to :recipe
end
