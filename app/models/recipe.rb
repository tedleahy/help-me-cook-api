class Recipe < ApplicationRecord
  has_many :ingredient_recipes
  has_many :ingredients, through: :ingredient_recipes

  def self.create_with_ingredients(recipe, ingredients)
    created_recipe = Recipe.create(recipe)
    { recipe: created_recipe,
      ingredients: create_ingredients_and_associations(created_recipe, ingredients) }
  end

  def self.create_ingredients_and_associations(created_recipe, ingredients)
    ingredients.map do |ingredient|
      created_ingredient = Ingredient.create(name: ingredient[:name])
      IngredientRecipe.create(recipe_id: created_recipe.id,
                              ingredient_id: created_ingredient.id,
                              amount: ingredient[:amount],
                              amount_unit: ingredient[:amount_unit])
      created_ingredient
    end
  end
  private_class_method :create_ingredients_and_associations
end
