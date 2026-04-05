FactoryBot.define do
  factory :product do
    name { Faker::Food.unique.ingredient }
    units { Product.units.keys.sample }
    category { Product.categories.keys.sample }
  end
end
