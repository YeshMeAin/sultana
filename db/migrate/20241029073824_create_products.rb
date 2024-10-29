class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :units
      t.float :price_per_unit
      t.boolean :in_bulk

      t.timestamps
    end
    add_index :products, :name
  end
end
