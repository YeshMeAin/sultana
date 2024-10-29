class Product < ApplicationRecord
  has_many :receipes, dependent: :destroy
  has_many :items, through: :receipes

  validates :name, presence: true
  validates :name, uniqueness: true
end
