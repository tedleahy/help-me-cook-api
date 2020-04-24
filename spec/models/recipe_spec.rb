require 'rails_helper'

describe Recipe do
  it 'has a valid factory' do
    expect(build(:recipe)).to be_valid
  end

  it 'must have a name' do
    recipe = build(:recipe, name: nil)
    expect(recipe).not_to be_valid
  end

  context 'with an association to some ingredients' do
    let(:recipe) { create(:recipe) }

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

describe Recipe, '.create_with_ingredients' do
  let(:recipe) { build(:recipe).attributes.compact.symbolize_keys }
  let(:ingredients) do
    [{ name: 'ingredient 1', amount: 1, amount_unit: 'tbsp' },
     { name: 'ingredient 2' }]
  end

  let!(:output) { Recipe.create_with_ingredients(recipe, ingredients) }

  it 'creates a recipe with correct attributes' do
    recipe_attributes = FactoryBot.attributes_for(:recipe).keys

    expect(output[:recipe].slice(*recipe_attributes)
                          .symbolize_keys
                          .keys)
      .to eq(recipe_attributes)
  end

  it 'creates ingredients with correct attributes' do
    expect(output[:ingredients].map { |i| i.slice(:name) })
      .to eq(ingredients.map { |i| i.slice(:name).stringify_keys })
  end

  it 'creates associations between the recipe and ingredients' do
    expect(output[:recipe].ingredients).to eq(output[:ingredients])
    expect(output[:ingredients].first.recipes.first).to eq(output[:recipe])
  end
end
