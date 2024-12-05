class OrdersController < ResourceController
  before_action :set_customers, only: %i[ new edit create update ]
  before_action :set_available_menu_items, only: %i[ new edit create update ]

  private
    def set_customers
      @customers = Customer.order(:name).select(:id, :name)
    end

    def set_available_menu_items
      @available_menu_items = MenuItem.currently_displayed
      @off_menu_items = Item.all
    end

    def trusted_params
      params.require(:order).permit(:customer_id, :due_date, order_items_attributes: [:id, :item_id, :quantity, :price, :_destroy])
    end
end
