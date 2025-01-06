class AddReadyAndOthToOrderItems < ActiveRecord::Migration[7.1]
  def change
    add_column :order_items, :ready, :boolean
    add_column :order_items, :oth, :boolean

    add_index :order_items, :oth
  end
end
