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

describe Ingredient, '.ingredient_name_and_amount' do
  it "returns a hash containing the ingredient's name, amount and amount_unit" do
    ingredient = build(:ingredient)
    ingredient_recipe = build(:ingredient_recipe, ingredient: ingredient)

    expect(ingredient_recipe.ingredient_name_and_amount).to eq(
      name: ingredient.name,
      amount: ingredient_recipe.amount,
      amount_unit: ingredient_recipe.amount_unit
    )
  end
end
