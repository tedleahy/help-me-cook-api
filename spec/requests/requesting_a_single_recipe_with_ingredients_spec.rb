require 'rails_helper'

describe 'Requesting a single recipe, with ingredients' do
  let!(:recipe) { create(:recipe_with_ingredients) }

  it 'returns the recipe, with its ingredients' do
    get "/recipe_with_ingredients/#{recipe.id}", headers: { 'ACCEPT' => 'application/json' }
    expect(response.body).to eq(
      {
        data: {
          id: recipe.id.to_s,
          type: 'recipe',
          attributes: {
            name: recipe.name,
            image_url: recipe.image_url,
            instructions: recipe.instructions,
            ingredients: recipe.ingredient_recipes.map(&:ingredient_name_and_amount)
          }
        }
      }.to_json
    )
  end
end
