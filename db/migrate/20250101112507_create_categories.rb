class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :display_name
      t.string :slug
      t.boolean :is_active
      t.integer :sort_order

      t.timestamps
    end
  end
end
