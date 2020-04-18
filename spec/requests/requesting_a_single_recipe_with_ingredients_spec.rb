# frozen_string_literal: true

require 'rails_helper'

describe 'Requesting a single recipe, with ingredients' do
  let!(:recipe) { create(:recipe_with_ingredients) }

  it 'returns the recipe, with its ingredients' do
    get "/recipe_with_ingredients/#{recipe.id}", headers: { 'ACCEPT' => 'application/json' }

    expect(response.body).to eq(RecipeSerializer.new(recipe).to_json)
  end
end
