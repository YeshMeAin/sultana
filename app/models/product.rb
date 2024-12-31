class Product < ApplicationRecord
  include ResourceAttributes

  has_many :receipes, dependent: :destroy
  has_many :items, through: :receipes

  validates :name, presence: true
  validates :name, uniqueness: true

  def self.table_attributes
    [:name, :price_per_unit, :units, :in_bulk]
  end

  def self.show_attributes
    [:name, :price_per_unit, :units, :in_bulk]
  end
end
