# frozen_string_literal: true

require 'rails_helper'

describe 'Searching for Recipes that contain a list of ingredients' do
  subject(:response_body) do
    headers = { 'CONTENT_TYPE' => 'application/json' }
    post '/search_recipes_by_ingredients', params: params, headers: headers
    JSON.parse(response.body)
  end

  let(:search_ingredients) { %w[carrots onions mince potatoes stock chopped\ tomatoes] }
  let!(:shepherds_pie) do
    create_recipe_with_ingredients({ name: "Shepherd's Pie" },
                                   [{ name: 'carrots', amount: 100, amount_unit: 'g' },
                                    { name: 'onions', amount: 2, amount_unit: 'whole' },
                                    { name: 'mince', amount: 400, amount_unit: 'g' },
                                    { name: 'potatoes', amount: 200, amount_unit: 'g' },
                                    { name: 'stock', amount: 500, amount_unit: 'ml' },
                                    { name: 'chopped tomatoes', amount: 400, amount_unit: 'g' }])
  end
  let!(:bolognese) do
    create_recipe_with_ingredients({ name: 'Bolognese' },
                                   [{ name: 'carrots', amount: 100, amount_unit: 'g' },
                                    { name: 'onions', amount: 2, amount_unit: 'whole' },
                                    { name: 'mince', amount: 400, amount_unit: 'g' },
                                    { name: 'chopped tomatoes', amount: 400, amount_unit: 'g' }])
  end
  let!(:beans_on_toast) do
    create_recipe_with_ingredients({ name: 'Beans on Toast' },
                                   [{ name: 'baked beans', amount: 400, amount_unit: 'g' },
                                    { name: 'bread', amount: 2, amount_unit: 'whole' },
                                    { name: 'butter' }])
  end

  context 'When sending an empty list of ingredients' do
    let(:params) { { ingredient_names: [] }.to_json }
    it 'returns an error to the client' do
      expect(response_body['error']).to eq('No search ingredients provided.')
    end
  end

  context 'When sending a non-empty list of ingredients' do
    let(:params) { { ingredient_names: search_ingredients }.to_json }
    let(:returned_recipe_names) { response_body['data'].map { |recipe| recipe['attributes']['name'] } }

    it 'returns recipes that use no more ingredients than the searched ones' do
      expect(returned_recipe_names).to include(shepherds_pie.name, bolognese.name)
    end

    it "does not return recipes that use ingredients that weren't searched for" do
      expect(returned_recipe_names).to_not include(beans_on_toast.name)
    end
  end
end
