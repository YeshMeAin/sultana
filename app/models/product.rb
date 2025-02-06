class Product < ApplicationRecord
  include ResourceAttributes

  has_many :recipes, dependent: :destroy
  has_many :items, through: :recipes

  validates :name, presence: true
  validates :name, uniqueness: true

  enum units: {
    piece: 0,
    kilogram: 1,
    gram: 2,
    liter: 3,
    milliliter: 4,
    package: 5
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
end
