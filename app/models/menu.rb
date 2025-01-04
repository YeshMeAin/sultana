class Menu < ApplicationRecord
  include ResourceAttributes

  has_many :menu_items, dependent: :destroy
  accepts_nested_attributes_for :menu_items, reject_if: :all_blank, allow_destroy: true

  has_many :items, through: :menu_items

  validates :name, presence: true
  validates :name, uniqueness: true

  def self.table_attributes
    [:name, :description, :currently_displayed]
  end

  def self.show_attributes
    [:name, :description, :currently_displayed, :created_at, :updated_at]
  end

  def menu_items_for_display
    menu_items.joins(item: :category)
      .where.not(categories: { id: nil })
      .select(
        'items.name as item_name, items.description as item_description, categories.sort_order as category_sort_order,
         categories.display_name as category_name, menu_items.price as price'
        )
      .order('categories.sort_order, items.name')
  end

  def associated_collections
    [{
      name: 'Menu Items',
      collection: menu_items.joins(:item)
        .select('items.name as item_name, menu_items.price as price')
    }]
  end
end

