require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it { should have_many(:items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:display_name) }
    it { should validate_presence_of(:slug) }
  end

  describe '.table_attributes' do
    it 'returns the correct attributes for table display' do
      expected_attributes = [:display_name, :slug, :is_active, :sort_order]
      expect(Category.table_attributes).to eq(expected_attributes)
    end
  end

  describe '.show_attributes' do
    it 'returns the correct attributes for detailed view' do
      expected_attributes = [:display_name, :slug, :is_active, :sort_order, :updated_at, :created_at]
      expect(Category.show_attributes).to eq(expected_attributes)
    end
  end

  describe 'ResourceAttributes module' do
    it 'includes associated_collections method from ResourceAttributes' do
      category = create(:category) # or Category.new(valid_attributes)
      expect(category.respond_to?(:associated_collections)).to be_truthy
      expect(category.associated_collections).to be_an(Array)
      expect(category.associated_collections).to be_empty
    end
  end
end
