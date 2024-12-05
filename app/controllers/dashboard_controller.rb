class DashboardController < ApplicationController
  def index
    @payed_this_month = Order.cached_where(
      status: :payed, 
      created_at: Time.current.beginning_of_month..Time.current.end_of_month
    ).sum(&:total_price)
    
    @orders_count_this_month = Order.cached_count
    @average_order_value = Order.average_total_price
    @open_orders = Order.open_orders
  end

  def generate_grocery_list
    # TODO: Implement
  end
end
