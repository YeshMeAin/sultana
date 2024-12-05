class MenuItem < ApplicationRecord
  belongs_to :menu
  belongs_to :item

  def self.currently_displayed
    joins(:menu, :item).where(menu: { currently_displayed: true }).select('menu_items.item_id, menu_items.price, items.name as name')
  end
end
