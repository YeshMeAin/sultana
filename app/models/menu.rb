class Menu < ApplicationRecord
  has_many :menu_items, dependent: :destroy
  has_many :items, through: :menu_items

  validates :name, presence: true
  validates :name, uniqueness: true

end

