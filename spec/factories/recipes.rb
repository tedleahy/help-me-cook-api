FactoryBot.define do
  factory :recipe do
    name { Faker::Food.dish }
    image_url { Faker::Internet.url(host: 'example.com', path: '/recipe_img.jpg') }
    instructions { Faker::Lorem.paragraphs(number: 3) }
    servings { Faker::Number.number(digits: 1) }
    source_url { Faker::Internet.url }
    prep_time_mins { Faker::Number.number(digits: 2) }
    cook_time_mins { Faker::Number.number(digits: 2) }
    total_time_mins { prep_time_mins + cook_time_mins }

    factory :recipe_with_ingredients do
      transient do
        ingredients_count { 2 }
      end

      after(:create) do |recipe, evaluator|
        ingredients = create_list(:ingredient, evaluator.ingredients_count)
        ingredients.each do |ingredient|
          create(:ingredient_recipe, ingredient: ingredient, recipe: recipe)
        end
      end
    end
  end
end
