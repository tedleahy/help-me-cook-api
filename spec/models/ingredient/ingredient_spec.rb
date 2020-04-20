require 'rails_helper'

describe Ingredient do
  it 'has a valid factory' do
    expect(build(:ingredient)).to be_valid
  end

  it 'must have a name' do
    ingredient = build(:ingredient, name: nil)
    expect(ingredient).not_to be_valid
  end

  context 'with an association to a recipe' do
    let(:ingredient) { create(:ingredient) }
    let(:recipe) { create(:recipe) }
    let!(:ingredient_recipe) { create(:ingredient_recipe, ingredient: ingredient, recipe: recipe) }

    it 'can access the ingredient_recipe join association' do
      expect(ingredient.ingredient_recipes).to eq([ingredient_recipe])
    end

    it 'can directly access the recipe through the ingredient_recipes join table' do
      expect(ingredient.recipes).to eq([recipe])
    end
  end
end
