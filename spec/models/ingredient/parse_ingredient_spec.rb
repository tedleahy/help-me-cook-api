require 'rails_helper'

describe Ingredient do
  describe 'Ingredient.parse_ingredient' do
    subject(:output) do
      Ingredient.parse(ingredient_str)
    end

    context 'a simple ingredient' do
      let(:ingredient_str) { '100g flour' }
      let(:expected_output) { { name: 'flour', amount: 100.0, amount_unit: 'g' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'an ingredient containing "of"' do
      let(:ingredient_str) { '100g of flour' }
      let(:expected_output) { { name: 'flour', amount: 100, amount_unit: 'g' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'a one-word ingredient' do
      let(:ingredient_str) { 'Salt' }
      let(:expected_output) { { name: 'salt', amount: nil, amount_unit: nil } }

      it { is_expected.to eq(expected_output) }
    end

    context 'a half measurement of an ingredient' do
      let(:ingredient_str) { '1/2 tsp garlic paste' }
      let(:expected_output) { { name: 'garlic paste', amount: 0.5, amount_unit: 'tsp' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'a whole ingredient beginning with "g"' do
      let(:ingredient_str) { '1 Green Chilli' }
      let(:expected_output) { { name: 'green chilli', amount: 1, amount_unit: 'whole' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'an ingredient measured in litres' do
      let(:ingredient_str) { '1L stock' }
      let(:expected_output) { { name: 'stock', amount: 1000, amount_unit: 'ml' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'an ingredient containing a vulgar unicode fraction (e.g. "½")' do
      let(:ingredient_str) { '½ Red Cabbage' }
      let(:expected_output) { { name: 'red cabbage', amount: 0.5, amount_unit: 'whole' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'an ingredient containing the full word "tablespoon", singular' do
      let(:ingredient_str) { '1 Tablespoon Miso Paste' }
      let(:expected_output) { { name: 'miso paste', amount: 1, amount_unit: 'tbsp' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'an ingredient containing the full word "tablespoons", plural' do
      let(:ingredient_str) { '3 Tablespoons Miso Paste' }
      let(:expected_output) { { name: 'miso paste', amount: 3, amount_unit: 'tbsp' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'an ingredient containing the full word "teaspoon", singular' do
      let(:ingredient_str) { '1 Teaspoon sugar' }
      let(:expected_output) { { name: 'sugar', amount: 1, amount_unit: 'tsp' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'an ingredient containing the full word "teaspoons", plural' do
      let(:ingredient_str) { '3 teaspoons sugar' }
      let(:expected_output) { { name: 'sugar', amount: 3, amount_unit: 'tsp' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'an ingredient containing the full word "gram", singular' do
      let(:ingredient_str) { '1 Gram sugar' }
      let(:expected_output) { { name: 'sugar', amount: 1, amount_unit: 'g' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'an ingredient containing the full word "grams", plural' do
      let(:ingredient_str) { '200 grams of spinach' }
      let(:expected_output) { { name: 'spinach', amount: 200, amount_unit: 'g' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'an ingredient with the word "half" for its amount' do
      let(:ingredient_str) { 'Half a Broccoli' }
      let(:expected_output) { { name: 'broccoli', amount: 0.5, amount_unit: 'whole' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'an ingredient measured in pints' do
      let(:ingredient_str) { '1 pint of whole milk' }
      let(:expected_output) { { name: 'whole milk', amount: 568.261, amount_unit: 'ml' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'an ingredient with a decimal amount' do
      let(:ingredient_str) { '1.5 tsp baking soda' }
      let(:expected_output) { { name: 'baking soda', amount: 1.5, amount_unit: 'tsp' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'an ingredient with an "x" after the amount' do
      let(:ingredient_str) { '2 x Tins of Black Beans' }
      let(:expected_output) { { name: 'tins of black beans', amount: 2, amount_unit: 'whole' } }

      it { is_expected.to eq(expected_output) }
    end

    context 'an ingredient with its price at the end' do
      context 'separated by a dash' do
        let(:ingredient_str) { '100g flour - £0.20' }

        it 'removes the price' do
          expect(output[:name]).to eq('flour')
        end
      end

      context 'separated by a colon' do
        let(:ingredient_str) { '100g flour: £0.20' }

        it 'removes the price' do
          expect(output[:name]).to eq('flour')
        end
      end
    end
  end
end
