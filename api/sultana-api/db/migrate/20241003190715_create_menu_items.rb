class CreateMenuItems < ActiveRecord::Migration[7.1]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.text :description
      t.float :price
      t.integer :units
      t.boolean :available

      t.timestamps
    end
    add_index :menu_items, :name
  end
end
