require 'rails_helper'

describe IngredientRecipe, type: :model do
  let(:ingredient_recipe) { create(:ingredient_recipe) }

  it 'has a valid factory' do
    expect(ingredient_recipe).to be_valid
  end
end
