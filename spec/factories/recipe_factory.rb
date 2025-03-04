FactoryBot.define do
  factory :recipe do
    product { create(:product) }
    quantity { Faker::Number.between(from: 1, to: 10) }
    units { Faker::Lorem.word }
  end
end