require 'rails_helper'

describe IngredientRecipe do
  it 'has a valid factory' do
    expect(build(:ingredient_recipe)).to be_valid
  end

  it 'must have an associated ingredient' do
    ingredient_recipe = build(:ingredient_recipe, ingredient: nil)
    expect(ingredient_recipe).not_to be_valid
  end

  it 'must have an associated recipe' do
    ingredient_recipe = build(:ingredient_recipe, recipe: nil)
    expect(ingredient_recipe).not_to be_valid
  end
end
