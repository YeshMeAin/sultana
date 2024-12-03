class Item < ApplicationRecord
  include ResourceAttributes

  has_many :menu_items
  has_many :menus, through: :menu_items

  has_many :recipes, dependent: :destroy
  accepts_nested_attributes_for :recipes, reject_if: :all_blank, allow_destroy: true

  def self.table_attributes
    [:name, :description]
  end

  def self.show_attributes
    [:name, :description, :updated_at, :created_at]
  end
end
