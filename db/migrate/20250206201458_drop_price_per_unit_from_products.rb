class DropPricePerUnitFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :price_per_unit
  end
end

