class DropInstructionsColumnFromRecipes < ActiveRecord::Migration[7.1]
  def change
    remove_column :recipes, :instructions
  end
end
