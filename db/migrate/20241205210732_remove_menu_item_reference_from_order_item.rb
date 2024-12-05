class RemoveMenuItemReferenceFromOrderItem < ActiveRecord::Migration[7.1]
  def change
    remove_column :order_items, :menu_item_id
  end
end
