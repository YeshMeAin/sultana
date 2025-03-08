class AddConversionFactorToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :conversion_factor, :float
  end
end
