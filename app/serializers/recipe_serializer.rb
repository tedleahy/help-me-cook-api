class RecipeSerializer
  include FastJsonapi::ObjectSerializer
  set_id :id
  attributes :name, :image_url, :instructions, :servings, :source_url, :prep_time_mins, :cook_time_mins,
             :total_time_mins

  attribute :ingredients do |recipe|
    recipe.ingredient_recipes.map(&:ingredient_details)
  end
end
