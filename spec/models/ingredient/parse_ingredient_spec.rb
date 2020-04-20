require 'rails_helper'

describe Ingredient do
  describe 'Ingredient.parse_ingredient' do
    let(:inputs_and_outputs) do
      [
        ['100g of flour', { name: 'flour', amount: 100, amount_unit: 'g' }],
        ['Salt', { name: 'salt', amount: nil, amount_unit: nil }]
      ]
    end

    it 'correctly parses a given ingredient' do
      expect(inputs_and_outputs.map { |input, output| Ingredient.parse(input) == output })
        .to eq(Array.new(inputs_and_outputs.length, true))
    end
  end
end
