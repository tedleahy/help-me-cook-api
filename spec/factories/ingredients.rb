FactoryBot.define do
  factory :ingredient do
    name { Faker::Food.ingredient }

    initialize_with { Ingredient.find_or_create_by(name: name) }
  end
end
