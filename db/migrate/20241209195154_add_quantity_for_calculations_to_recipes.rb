class AddQuantityForCalculationsToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :quantity_for_calculations, :float
    add_column :recipes, :units_for_calculations, :string
    add_column :recipes, :units_for_display, :string
    
    remove_column :recipes, :quantity
    add_column :recipes, :quantity_for_display, :float
  end
end
