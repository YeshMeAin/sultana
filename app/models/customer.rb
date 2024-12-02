class Customer < ApplicationRecord
  include ResourceAttributes

  def self.table_attributes
    [:name, :email, :phone, :created_at]
  end

  def self.show_attributes
    [:name, :email, :phone, :created_at, :updated_at, :orders]
  end
end
