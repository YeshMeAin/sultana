class Customer < ApplicationRecord
  include ResourceAttributes

  has_many :orders

  validates :name, :phone, presence: true

  def self.table_attributes
    [:name, :email, :phone, :created_at]
  end

  def self.show_attributes
    [:name, :email, :phone, :created_at, :updated_at]
  end

  def associated_collections
    [{
      name: 'Orders',
      collection: orders.select(:id, :due_date, :status).map do |order|
        {
          due_date: order.due_date,
          status: order.status,
          total_price: order.total_price
        }
      end
    }]
  end
end
