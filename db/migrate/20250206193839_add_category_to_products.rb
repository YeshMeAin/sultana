class AddCategoryToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :category, :integer
    add_index :products, :category
  end
end
