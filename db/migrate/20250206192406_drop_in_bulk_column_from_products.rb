class DropInBulkColumnFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :in_bulk
  end
end
