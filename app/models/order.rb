class Order < ApplicationRecord
  include CacheableQueries
  include ResourceAttributes

  after_commit :clear_cache

  belongs_to :customer
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true
  has_many :items, through: :order_items

  validates :customer, presence: true
  validates :order_items, presence: true, unless: :cancelled?
  validate :has_valid_items, unless: :cancelled?

  scope :since, ->(date) { where('orders.created_at > ?', date) } # explicit call to orders table is to allow usage with joins
  scope :open_orders, -> { where.not(status: 'paid').order(created_at: :desc).includes(:customer) }

  enum status: {
    pending: 0,
    confirmed: 1,
    preparing: 2,
    ready: 3,
    delivered: 4,
    payed: 5,
    cancelled: 6
  }

  include AASM

  aasm column: :status, whiny_persistence: true do
    state :pending, initial: true
    state :confirmed, :preparing, :ready, :delivered
    state :payed, :cancelled # final states

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
      transitions from: :delivered, to: :payed
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
    result = Order.since(since)
        .joins(:order_items)
        .select(
          'AVG(order_items.quantity * order_items.price) AS average_order_value'
        )
        .group('orders.id')
    
    result.average('average_order_value')
  end

  def associated_collections
    [{
      name: 'Order Items',
      collection: order_items.joins(:item)
        .select('items.name AS item_name, order_items.price AS item_price, order_items.quantity, (order_items.quantity * order_items.price) AS total_price, order_items.notes')
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

  def clear_cache
    Rails.cache.delete_matched("#{self.class.cache_key_prefix}*")
  end

  def has_valid_items
    errors.add(:base, "Order must have at least one item") if order_items.empty?
    errors.add(:base, "Order items must have positive quantities") if order_items.any? { |item| item.quantity.to_f <= 0 }
  end
end
