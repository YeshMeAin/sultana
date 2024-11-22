class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :address

      t.timestamps
    end
    add_index :customers, :name
    add_index :customers, :email
  end
end
