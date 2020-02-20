require 'rails_helper'

describe 'Requesting a single recipe' do
  let!(:recipe) { create(:recipe) }

  it 'returns the recipe' do
    get "/recipes/#{recipe.id}", headers: { 'ACCEPT' => 'application/json' }
    expect(response.body).to eq(recipe.to_json)
  end
end
