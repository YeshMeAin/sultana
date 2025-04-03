class CategoriesController < ResourceController
  before_action :set_category, only: %i[ show edit update destroy ]

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:display_name, :slug, :is_active, :sort_order, :description)
    end
end
