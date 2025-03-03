require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'associations' do
    it { should have_many(:orders) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone) }
  end

  describe '.table_attributes' do
    it 'returns the correct attributes for table display' do
      expected_attributes = [:name, :email, :phone, :created_at]
      expect(Customer.table_attributes).to eq(expected_attributes)
    end
  end

  describe '.show_attributes' do
    it 'returns the correct attributes for detailed view' do
      expected_attributes = [:name, :email, :phone, :created_at, :updated_at]
      expect(Customer.show_attributes).to eq(expected_attributes)
    end
  end

  describe 'ResourceAttributes module' do
    it 'includes associated_collections method from ResourceAttributes' do
      customer = create(:customer)
      expect(customer.respond_to?(:associated_collections)).to be_truthy
      expect(customer.associated_collections).to be_an(Array)
      expect(customer.associated_collections.first[:name]).to eq('Orders')
    end
  end
end
