class ItemsController < ResourceController
  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :set_available_products, only: %i[ new edit create update ]

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def set_available_products
      @available_products = Product.select(:id, :name)
    end

    def trusted_params
      params.require(:item).permit(:name, :description, :price, :category_id,
        recipes_attributes: [:id, :product_id, :quantity_for_calculations, :units_for_calculations, :units_for_display, :quantity_for_display, :_destroy])
    end
end
