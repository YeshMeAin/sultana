class AddIndexToOrdersCreatedAt < ActiveRecord::Migration[7.1]
  def change
    add_index :orders, :created_at
  end
end
