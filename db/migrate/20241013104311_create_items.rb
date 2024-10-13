class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.float :price

      t.timestamps
    end
    add_index :items, :name
  end
end
