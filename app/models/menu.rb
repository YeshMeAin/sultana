class Menu < ApplicationRecord
  has_many :menu_items, dependent: :destroy
  accepts_nested_attributes_for :menu_items, reject_if: :all_blank, allow_destroy: true

  has_many :items, through: :menu_items

  validates :name, presence: true
  validates :name, uniqueness: true

end

