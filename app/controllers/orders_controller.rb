class OrdersController < ResourceController
  before_action :set_order, only: %i[ confirm prepare ready deliver pay ]
  before_action :set_customers, only: %i[ new edit create update ]
  before_action :set_available_items, only: %i[ new edit create update ]

  def confirm
    @order.confirm!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to dashboard_path, notice: "Order #{@order.id} confirmed" }
    end
  end

  def prepare
    @order.prepare!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to dashboard_path, notice: "Order #{@order.id} prepared" }
    end
  end

  def ready
    @order.ready!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to dashboard_path, notice: "Order #{@order.id} ready" }
    end
  end

  def deliver
    @order.deliver!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to dashboard_path, notice: "Order #{@order.id} delivered" }
    end
  end

  def pay
    @order.pay!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to dashboard_path, notice: "Order #{@order.id} paid" }
    end
  end 

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def set_customers
      @customers = Customer.order(:name).select(:id, :name)
    end

    def set_available_items
      @available_items = Item.with_prices
    end

    def trusted_params
      params.require(:order).permit(:customer_id, :due_date, order_items_attributes: [:id, :item_id, :quantity, :oth, :price, :_destroy])
    end
end
