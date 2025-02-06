class ChangeUnitsToEnumOnProducts < ActiveRecord::Migration[7.1]
  def change
    change_column :products, :units, :integer, using: 'units::integer'
  end
end
