require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { create(:product) }

  describe 'associations' do
    it { should have_many(:recipes).dependent(:destroy) }
    it { should have_many(:items).through(:recipes) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'enums' do
    it { should define_enum_for(:units).with_values(piece: 0, gram: 1, milliliter: 2) }
    it { should define_enum_for(:calculation_units).with_values(calc_piece: 0, calc_gram: 1, calc_milliliter: 2) }
    it { should define_enum_for(:category).with_values(vegetables: 0, fruits: 1, meat: 2, dairy: 3, fish: 4, grains: 5, spices: 6, oils: 7) }
  end

  describe 'class methods' do
    describe '.table_attributes' do
      it 'returns the correct attributes' do
        expect(Product.table_attributes).to eq([:name, :units, :category])
      end
    end
    
    describe '.show_attributes' do
      it 'returns the correct attributes' do
        expect(Product.show_attributes).to eq([:name, :units, :category])
      end
    end
    
    describe '.format_quantity' do
      context 'with gram units' do
        it 'formats grams correctly' do
          expect(Product.format_quantity(500, :gram)).to eq("500.0 g")
        end
        
        it 'converts to kilograms for large amounts' do
          expect(Product.format_quantity(1500, :gram)).to eq("1.5 kg")
        end
      end
      
      context 'with milliliter units' do
        it 'formats milliliters correctly' do
          expect(Product.format_quantity(750, :milliliter)).to eq("750.0 ml")
        end
        
        it 'converts to liters for large amounts' do
          expect(Product.format_quantity(2500, :milliliter)).to eq("2.5 L")
        end
      end
      
      context 'with piece units' do
        it 'formats pieces correctly' do
          expect(Product.format_quantity(3, :piece)).to eq("3.0 piece")
        end
      end
      
      it 'rounds to 2 decimal places' do
        expect(Product.format_quantity(1.2345, :gram)).to eq("1.23 g")
      end
    end
  end

  describe 'instance methods' do
    describe '#adjusted_quantity' do
      context 'when units match calculation_units' do
        let(:product) { create(:product, units: :piece, calculation_units: :calc_piece) }
        
        it 'returns the original quantity' do
          expect(product.adjusted_quantity(5)).to eq(5)
        end
      end
      
      context 'when converting piece with conversion factor' do
        let(:product) { create(:product, units: :piece, calculation_units: :calc_gram, conversion_factor: 250) }
        
        it 'multiplies by the conversion factor' do
          expect(product.adjusted_quantity(2)).to eq(500)
        end
      end
      
      context 'with invalid conversion' do
        let(:product) { create(:product, units: :piece, calculation_units: :calc_gram, conversion_factor: nil) }
        
        it 'logs an error and returns original quantity' do
          expect(Rails.logger).to receive(:error).with(/Invalid conversion for product/)
          expect(product.adjusted_quantity(3)).to eq(3)
        end
      end
    end
  end

  describe 'ResourceAttributes module' do
    it 'includes the ResourceAttributes module' do
      expect(Product.ancestors).to include(ResourceAttributes)
    end
  end
end 