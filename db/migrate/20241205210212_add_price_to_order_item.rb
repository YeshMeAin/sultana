class AddPriceToOrderItem < ActiveRecord::Migration[7.1]
  def change
    add_column :order_items, :price, :float
  end
end
