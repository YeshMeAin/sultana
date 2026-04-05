class DropUnusedMenuItemColumns < ActiveRecord::Migration[7.1]
  def change
    remove_column :menu_items, :quantity, :integer
    remove_column :menu_items, :units, :string
  end
end
