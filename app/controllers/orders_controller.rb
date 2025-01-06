class OrdersController < ResourceController
  before_action :set_customers, only: %i[ new edit create update ]
  before_action :set_available_items, only: %i[ new edit create update ]

  private
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
