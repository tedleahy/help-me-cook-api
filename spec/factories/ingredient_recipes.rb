FactoryBot.define do
  factory :ingredient_recipe do
    ingredient
    recipe
    amount { Faker::Number.decimal(l_digits: 1, r_digits: 1) }
    amount_unit { IngredientRecipe::MEASUREMENT_UNITS.sample }
  end
end
