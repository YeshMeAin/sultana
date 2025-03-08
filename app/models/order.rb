class Order < ApplicationRecord
  include ResourceAttributes

  after_save :update_grocery_list, if: :saved_change_to_status?

  belongs_to :customer
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true
  has_many :items, through: :order_items

  validates :customer, presence: true

  scope :since, ->(date) { where('orders.created_at > ?', date) } # explicit call to orders table is to allow usage with joins
  scope :open_orders, -> { where.not(status: ['paid', 'cancelled']).order(created_at: :desc).includes(:customer) }

  enum status: {
    pending: 0,
    confirmed: 1,
    preparing: 2,
    ready: 3,
    delivered: 4,
    paid: 5,
    cancelled: 6
  }

  include AASM

  aasm column: :status, whiny_persistence: true do
    state :pending, initial: true
    state :confirmed, :preparing, :ready, :delivered
    state :paid, :cancelled # final states

    event :confirm do
      transitions from: :pending, to: :confirmed
    end

    event :prepare do
      transitions from: :confirmed, to: :preparing
    end

    event :ready do
      transitions from: :preparing, to: :ready
    end

    event :deliver do
      transitions from: :ready, to: :delivered
    end

    event :pay do
      transitions from: :delivered, to: :paid
    end

    event :cancel do
      transitions from: [:pending, :confirmed], to: :cancelled
    end
  end

  def self.table_attributes
    [:customer_name, :status, :due_date, :total_price]
  end

  def self.show_attributes
    [:customer_name, :customer_phone, :status, :created_at, :due_date, :updated_at]
  end

  def self.average_total_price(since: Time.at(0))
    # Use a subquery to first calculate the total for each order, then average those totals
    subquery = Order.since(since)
      .joins(:order_items)
      .select('orders.id, SUM(order_items.quantity * order_items.price) AS order_total')
      .group('orders.id')
      .to_sql

    Order.connection.select_value(
      "SELECT AVG(order_total) FROM (#{subquery}) AS order_totals"
    ).to_f
  end

  def associated_collections
    [{
      name: 'Order Items',
      collection: order_items.joins(:item)
        .select('items.name AS item_name, order_items.price AS item_price, order_items.quantity, (order_items.quantity * order_items.price) AS total_price, order_items.notes, order_items.oth')
        .order('items.name')
    }]
  end

  def total_price
    order_items.sum { |item| item.price * item.quantity }
  end

  def count
    order_items.count
  end

  def customer_name
    customer.name
  end

  def customer_phone
    customer.phone
  end

  private

  def update_grocery_list
    if previous_changes["status"] && previous_changes["status"][1] == "confirmed"
      # Order was just confirmed - add items to grocery list
      GroceryListManager.add_order(self)
    elsif previous_changes["status"] && previous_changes["status"][0] == "confirmed"
      # Order was moved from confirmed to another status - remove items from grocery list
      GroceryListManager.remove_order(self)
    end
  end
end
