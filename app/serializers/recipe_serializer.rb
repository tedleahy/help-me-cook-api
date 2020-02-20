class RecipeSerializer
  include FastJsonapi::ObjectSerializer
  set_id :id
  attributes :name, :image_url

  attribute :ingredients do |recipe|
    recipe.ingredient_recipes.map do |ir|
      { name: ir.ingredient.name,
        amount: ir.amount,
        amount_unit: ir.amount_unit }
    end
  end
end
