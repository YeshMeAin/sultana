class Item < ApplicationRecord
  has_many :menu_items
  has_many :menus, through: :menu_items

  has_many :receipes
  accepts_nested_attributes_for :receipes

end
