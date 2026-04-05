FactoryBot.define do
  factory :recipe do
    product { create(:product) }
    item { create(:item) }
    quantity { Faker::Number.between(from: 1, to: 10) }
    units { Recipe.units.keys.sample }
  end
end
