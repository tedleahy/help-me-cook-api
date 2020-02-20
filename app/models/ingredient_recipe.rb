class IngredientRecipe < ApplicationRecord
  MEASUREMENT_UNITS = %w[ml grams tbsp tsp].freeze

  belongs_to :ingredient
  belongs_to :recipe
end
