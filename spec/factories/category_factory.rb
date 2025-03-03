FactoryBot.define do
  factory :category do
    display_name { Faker::Lorem.word }
    slug { display_name.parameterize }
    is_active { true }
    sort_order { Faker::Number.between(from: 1, to: 100) }
  end
end
