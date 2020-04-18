# frozen_string_literal: true

require 'rails_helper'

describe 'Requesting all recipes with their ingredients' do
  let!(:recipes) { create_list(:recipe_with_ingredients, 2) }

  it 'returns all recipes, with their ingredients' do
    get '/recipes_with_ingredients', headers: { 'ACCEPT' => 'application/json' }

    expect(response.body).to eq(RecipeSerializer.new(recipes).to_json)
  end
end
