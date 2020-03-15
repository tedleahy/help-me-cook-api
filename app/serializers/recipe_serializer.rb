class RecipeSerializer
  include FastJsonapi::ObjectSerializer
  set_id :id
  attributes :name, :image_url, :instructions

  attribute :ingredients do |recipe|
    recipe.ingredient_recipes.map(&:ingredient_details)
  end
end
