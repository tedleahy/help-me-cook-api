class RecipeSerializer
  include FastJsonapi::ObjectSerializer
  set_id :id
  attributes :name, :image_url

  attribute :ingredients do |recipe|
    recipe.ingredient_recipes.map(&:ingredient_name_and_amount)
  end
end
