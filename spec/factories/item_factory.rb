FactoryBot.define do
  factory :item do
    name { Faker::Food.dish }
    description { Faker::Lorem.sentence }
    is_vegan { false }
    is_popular { false }
    is_new { false }
    category { create(:category) }
    recipes { [create(:recipe)] }
  end
end
