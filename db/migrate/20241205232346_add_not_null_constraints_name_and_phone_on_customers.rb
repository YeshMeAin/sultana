class AddNotNullConstraintsNameAndPhoneOnCustomers < ActiveRecord::Migration[7.1]
  def change
    change_column_null :customers, :name, false
    change_column_null :customers, :phone, false
  end
end
