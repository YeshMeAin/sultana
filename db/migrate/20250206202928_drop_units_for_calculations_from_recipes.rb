class DropUnitsForCalculationsFromRecipes < ActiveRecord::Migration[7.1]
  def change
    remove_column :recipes, :units_for_calculations
  end
end
