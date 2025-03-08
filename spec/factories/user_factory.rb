FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }

    trait :admin do
      admin { true }
    end

    trait :with_custom_email do
      transient do
        domain { 'example.com' }
      end
      
      email { "user_#{SecureRandom.hex(4)}@#{domain}" }
    end
  end
end
