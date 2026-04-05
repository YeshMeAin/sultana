class Recipe < ApplicationRecord
  belongs_to :product
  belongs_to :item

  enum units: {
    piece: 0,
    kilogram: 1,
    gram: 2,
    liter: 3,
    milliliter: 4,
    package: 5
  }

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :units, presence: true
end
