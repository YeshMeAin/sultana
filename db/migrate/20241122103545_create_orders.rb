class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.datetime :due_date
      t.integer :status

      t.timestamps
    end
  end
end
