require 'rails_helper'

describe Ingredient, type: :model do
  let(:ingredient) { create(:ingredient) }

  it 'has a valid factory' do
    expect(ingredient).to be_valid
  end
end
