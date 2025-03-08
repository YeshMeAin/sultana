FactoryBot.define do
  factory :recipe do
    product { create(:product) }
    quantity_for_display { Faker::Number.between(from: 1, to: 10) }
    units_for_display { 'pieces' }
  end
end