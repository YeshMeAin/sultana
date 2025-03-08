class DashboardController < ApplicationController
  def index
    @payed_this_month = Order.where(
      status: :payed, 
      created_at: Time.current.beginning_of_month..Time.current.end_of_month
    ).sum(&:total_price)
    
    @orders_count_this_month = Order.since(Time.current.beginning_of_month).count
    @average_order_value = Order.average_total_price
    @open_orders = Order.open_orders
  end

  def generate_grocery_list
    @grocery_list = format_grocery_list(GroceryListManager.get_list)
    
    respond_to do |format|
      format.html { head :not_acceptable }
      format.json { render json: @grocery_list }
    end
  end
  
  def update_grocery_item
    product_id = params[:product_id]
    checked = params[:checked] == 'true'
    
    success = GroceryListManager.update_item_status(product_id, checked)
    
    respond_to do |format|
      format.json { render json: { success: success } }
    end
  end
  
  def refresh_grocery_list
    # Force refresh from current confirmed orders
    GroceryListManager.clear_list
    
    Order.where(status: :confirmed).each do |order|
      GroceryListManager.add_order(order)
    end
    
    redirect_to generate_grocery_list_path, notice: "Grocery list has been refreshed"
  end
  
  private
  
  def format_grocery_list(list)
    # Convert hash to array and sort by category and name
    list.values.sort_by { |item| [item["category"] || "", item["name"]] }
  end
end
