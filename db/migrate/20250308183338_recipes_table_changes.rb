class RecipesTableChanges < ActiveRecord::Migration[7.1]
  def change
    rename_column :recipes, :quantity_for_display, :quantity
    remove_column :recipes, :quantity_for_calculations
    remove_column :recipes, :units_for_display
  end
end
