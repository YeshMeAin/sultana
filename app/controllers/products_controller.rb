class ProductsController < ResourceController
  before_action :set_products, only: %i[ new edit create update ]

  private
    def set_products
      @products = Product.order(:name).select(:id, :name)
    end

    def trusted_params
      params.require(:product).permit(:name, :price_per_unit, :units)
    end
end
