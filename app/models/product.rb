class Product < ApplicationRecord
  include ResourceAttributes

  has_many :recipes, dependent: :destroy
  has_many :items, through: :recipes

  validates :name, presence: true
  validates :name, uniqueness: true

  enum units: {
    piece: 0,
    gram: 1,
    milliliter: 2
  }

  enum calculation_units: {
    calc_piece: 0,
    calc_gram: 1,
    calc_milliliter: 2
  }

  enum category: {
    vegetables: 0,
    fruits: 1,
    meat: 2,
    dairy: 3,
    fish: 4,
    grains: 5,
    spices: 6,
    oils: 7
  }

  def self.table_attributes
    [:name, :units, :category]
  end

  def self.show_attributes
    [:name, :units, :category]
  end

  def self.format_quantity(amount, unit)
    formatted_amount = amount.round(2)
    
    case unit.to_sym
    when :gram
      if formatted_amount >= 1000
        "#{(formatted_amount / 1000.0).round(1)} kg"
      else
        "#{formatted_amount.to_f} g"
      end
    when :milliliter
      if formatted_amount >= 1000
        "#{(formatted_amount / 1000.0).round(1)} L"
      else
        "#{formatted_amount.to_f} ml"
      end
    else
      "#{formatted_amount.to_f} #{unit}"
    end
  end

  def adjusted_quantity(quantity)
    if units.to_s == calculation_units.to_s.sub('calc_', '')
      quantity
    elsif units == 'piece' && conversion_factor.present?
      quantity * conversion_factor
    else 
      Rails.logger.error("Invalid conversion for product #{name}: #{units}")
      quantity
    end
  end
end
