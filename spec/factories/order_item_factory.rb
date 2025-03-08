FactoryBot.define do
  factory :order_item do
    order { create(:order) }
    item { create(:item) }
    quantity { Faker::Number.between(from: 1, to: 10) }
    price { Faker::Number.between(from: 1, to: 100) }
  end
end