require 'rails_helper'

describe Recipe, type: :model do
  let(:recipe) { create(:recipe) }

  it 'has a valid factory' do
    expect(recipe).to be_valid
  end

  context 'with an association to some ingredients' do
    let(:ingredients) { create_list(:ingredient, 2) }
    let!(:ingredient_recipes) do
      ingredients.map { |ingredient| create(:ingredient_recipe, ingredient: ingredient, recipe: recipe) }
    end

    it 'can access the ingredient_recipe join association' do
      expect(recipe.ingredient_recipes).to eq(ingredient_recipes)
    end

    it 'can directly access its ingredients through the ingredient_recipes join table' do
      expect(recipe.ingredients).to eq(ingredients)
    end
  end
end
