class Item < ApplicationRecord
  has_many :menu_items
  has_many :menus, through: :menu_items

  has_many :recipes, dependent: :destroy
  accepts_nested_attributes_for :recipes, reject_if: :all_blank, allow_destroy: true
end
