require 'rails_helper'

describe Recipe, type: :model do
  let(:recipe) { create(:recipe) }

  it 'has a valid factory' do
    expect(recipe).to be_valid
  end
end
