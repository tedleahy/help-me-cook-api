require 'rails_helper'

describe 'Requesting all recipes with their ingredients' do
  let!(:recipes) { create_list(:recipe_with_ingredients, 2) }

  it 'returns all recipes, with their ingredients' do
    get '/recipes_with_ingredients', headers: { 'ACCEPT' => 'application/json' }
    recipes_with_ingredients = recipes.map do |recipe|
      {
        id: recipe.id.to_s,
        type: 'recipe',
        attributes: {
          name: recipe.name,
          image_url: recipe.image_url,
          instructions: recipe.instructions,
          ingredients: recipe.ingredient_recipes.map(&:ingredient_name_and_amount)
        }
      }
    end

    expect(response.body).to eq({ data: recipes_with_ingredients }.to_json)
  end
end
