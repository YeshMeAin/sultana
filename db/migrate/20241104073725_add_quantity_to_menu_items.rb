class AddQuantityToMenuItems < ActiveRecord::Migration[7.1]
  def change
    add_column :menu_items, :quantity, :integer
    add_column :menu_items, :units, :string
  end
end
