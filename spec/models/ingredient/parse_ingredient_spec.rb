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
  end
end
