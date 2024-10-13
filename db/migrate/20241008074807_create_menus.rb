class CreateMenus < ActiveRecord::Migration[7.1]
  def change
    create_table :menus do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :currently_displayed, default: false

      t.timestamps
    end
    add_index :menus, :name
  end
end
