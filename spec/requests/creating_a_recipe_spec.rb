require 'rails_helper'

describe 'Creating a Recipe' do
  subject(:api_response) do
    headers = { 'CONTENT_TYPE' => 'application/json' }
    post '/recipes/create', params: recipe_json, headers: headers
    JSON.parse(response.body)
  end

  context 'when POSTing valid JSON' do
    let(:recipe) { attributes_for(:recipe) }
    let(:recipe_json) do
      recipe.merge({
                     ingredients: [
                       { name: 'ingredient 1', amount: 1, amount_unit: 'g' },
                       { name: 'ingredient 2', amount: nil, amount_unit: nil }
                     ]
                   }).to_json
    end

    it 'returns the created recipe as JSON' do
      returned_recipe = api_response['data']['attributes']
      # ignore the id, as we can't know what it will be before it's returned
      returned_recipe['ingredients'].map! { |ingredient| ingredient.except('id') }

      expect(returned_recipe).to eq(JSON.parse(recipe_json))
    end
  end

  context 'when POSTing invalid JSON' do
    let(:recipe_json) { { name: nil, image_url: nil, ingredients: [] }.to_json }

    it 'returns a message stating that there was an error' do
      expect(api_response).to eq({ 'message' => 'Error creating recipe' })
    end
  end
end
