require 'rails_helper'

describe 'Creating a Recipe' do
  subject(:response_message) do
    headers = { 'CONTENT_TYPE' => 'application/json' }
    post '/recipes/create', params: recipe_json, headers: headers
    JSON.parse(response.body)['message']
  end

  context 'when POSTing valid JSON' do
    let(:recipe) { attributes_for(:recipe) }
    let(:recipe_json) do
      {
        name: recipe[:name],
        image_url: recipe[:image_url],
        ingredients: [
          { name: 'ingredient 1', amount: 1, amount_unit: 'g' },
          { name: 'ingredient 2' }
        ]
      }.to_json
    end

    it 'returns a message stating that the recipe was created' do
      expect(response_message).to eq("New recipe #{recipe[:name]} successfully created")
    end
  end

  context 'when POSTing invalid JSON' do
    let(:recipe_json) { { name: nil, image_url: nil, ingredients: [] }.to_json }

    it 'returns a message stating that there was an error' do
      expect(response_message).to eq('Error creating recipe')
    end
  end
end
