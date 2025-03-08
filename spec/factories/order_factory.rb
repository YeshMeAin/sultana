FactoryBot.define do
  factory :order do
    customer { create(:customer) }
    due_date { Faker::Time.between(from: 1.day.ago, to: 1.day.from_now) }
    
    # Trait for creating with items of specific quantity and price
    trait :with_custom_items do
      transient do
        items_attributes { [{ quantity: 2, price: 10.0 }, { quantity: 1, price: 20.0 }] } # Array of hashes with quantity and price
      end
      
      after(:create) do |order, evaluator|
        # Create new items based on attributes
        evaluator.items_attributes.each do |attrs|
          order.order_items << build(:order_item, order: order, quantity: attrs[:quantity], price: attrs[:price])
        end
        
        # Reload to ensure the association is fresh
        order.reload
      end
    end
  end
end
