require 'rails_helper'

describe 'Requesting all recipes' do
  let!(:recipes) { create_list(:recipe, 2) }

  it 'returns all recipes' do
    get '/recipes', headers: { 'ACCEPT' => 'application/json' }
    expect(response.body).to eq(recipes.to_json)
  end
end
