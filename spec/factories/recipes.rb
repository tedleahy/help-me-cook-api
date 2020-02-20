FactoryBot.define do
  factory :recipe do
    name { Faker::Food.dish }
    image_url { Faker::Internet.url(host: 'example.com', path: '/recipe_img.jpg') }
  end
end
