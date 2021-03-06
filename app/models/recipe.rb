class Recipe < ApplicationRecord
  has_many :ingredient_recipes, dependent: :destroy
  has_many :ingredients, through: :ingredient_recipes

  validates :name, presence: true

  def self.create_with_ingredients(recipe, ingredients)
    recipe[:name] = recipe[:name]&.titleize
    created_recipe = Recipe.create(recipe)
    return false unless created_recipe.valid?

    { recipe: created_recipe,
      ingredients: create_ingredients_and_associations(created_recipe, ingredients) }
  end

  def self.create_ingredients_and_associations(created_recipe, ingredients)
    return false unless created_recipe.valid? && ingredients

    ingredients.map do |ingredient|
      created_ingredient = FactoryBot.create(:ingredient, name: ingredient[:name])
      FactoryBot.create(:ingredient_recipe, recipe_id: created_recipe.id,
                                            ingredient_id: created_ingredient.id,
                                            amount: ingredient[:amount],
                                            amount_unit: ingredient[:amount_unit])
      created_ingredient
    end
  end
  private_class_method :create_ingredients_and_associations
end
