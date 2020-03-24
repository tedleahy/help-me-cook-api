# frozen_string_literal: true

require 'spec_helper'

module RecipeHelper
  def create_recipe_with_ingredients(recipe_attributes = {}, ingredients = [])
    recipe = create(:recipe, recipe_attributes)
    ingredients.each do |ingredient|
      created_ingredient = create(:ingredient, name: ingredient[:name])
      create(:ingredient_recipe, ingredient: created_ingredient,
                                 recipe: recipe,
                                 amount: ingredient[:amount],
                                 amount_unit: ingredient[:amount_unit])
    end

    recipe
  end
end
