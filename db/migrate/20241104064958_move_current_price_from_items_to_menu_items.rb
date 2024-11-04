class MoveCurrentPriceFromItemsToMenuItems < ActiveRecord::Migration[7.1]
  def change
    add_column :menu_items, :price, :float
    remove_column :items, :price
  end
end
