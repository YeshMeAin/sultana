class ProductsController < ResourceController
  before_action :set_products, only: %i[ new edit create update ]

  private
    def set_products
      @products = Product.order(:name).select(:id, :name)
    end

    def trusted_params
      params.require(:product).permit(:name, :units, :category, :calculation_units)
    end
end
