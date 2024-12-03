class ItemsController < ResourceController
  before_action :set_item, only: %i[ show edit update destroy ]

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def trusted_params
      params.require(:item).permit(:name, :description, :price,
        recipes_attributes: [:id, :product_id, :quantity, :instructions, :_destroy])
    end
end
