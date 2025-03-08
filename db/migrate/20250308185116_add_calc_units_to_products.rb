class AddCalcUnitsToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :calculation_units, :integer, default: 0
  end
end
