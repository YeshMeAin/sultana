class SimplifyRecipeColumns < ActiveRecord::Migration[7.1]
  def change
    remove_column :recipes, :quantity_for_display, :float
    remove_column :recipes, :units_for_display, :string
    rename_column :recipes, :quantity_for_calculations, :quantity
    add_column :recipes, :units, :integer, default: 0, null: false
  end
end
