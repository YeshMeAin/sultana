class Order < ApplicationRecord
  include CacheableQueries

  after_commit :clear_cache

  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_many :menu_items, through: :order_items

  include AASM

  aasm column: :status, enum: true, whiny_persistence: true do
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

  def self.average_total_price(since: Time.at(0))
    Rails.cache.fetch([cache_key_prefix, 'average_total_price', since], expires_in: EXPIRATION_TIME) do
      where('created_at > ?', since)
        .select('AVG(total) as avg_total')
        .from(
          select('orders.id, SUM(order_items.quantity * menu_items.price) as total')
          .joins(order_items: :menu_item)
          .group('orders.id')
        )
        .pick('avg_total') || 0
    end
  end

  def total_price
    order_items
      .joins(:menu_item)
      .select('SUM(menu_items.price * order_items.quantity) as order_total')
      .pick('order_total') || 0
  end

  def count
    order_items.count
  end

  private

  def clear_cache
    Rails.cache.delete_matched("#{self.class.cache_key_prefix}*")
  end
end
