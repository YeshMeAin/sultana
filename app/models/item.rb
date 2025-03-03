class Item < ApplicationRecord
  include ResourceAttributes

  belongs_to :category, optional: true

  has_many :menu_items
  has_many :menus, through: :menu_items

  has_many :recipes, dependent: :destroy
  accepts_nested_attributes_for :recipes, reject_if: :all_blank, allow_destroy: true

  scope :index_order, -> { order(category_id: :asc, name: :asc) }

  scope :with_prices, -> {
    left_joins(menu_items: :menu)
    .select('items.id as item_id, items.name as name, COALESCE(CASE WHEN menus.currently_displayed = true THEN menu_items.price ELSE 0 END, 0) AS price')
    .order('items.name ASC')
  }

  def self.table_attributes
    [:name, :description, :category_name, :is_vegan, :is_popular, :is_new]
  end

  def self.show_attributes
    [:name, :description, :updated_at, :created_at, :is_vegan, :is_popular, :is_new]
  end

  def category_name
    category&.display_name
  end

  def associated_collections
    [{
      name: 'Recipe',
      collection: recipes.joins(:product)
        .select('products.name as product_name, recipes.quantity_for_display as quantity, recipes.units_for_display as units')
    }]
  end
end
