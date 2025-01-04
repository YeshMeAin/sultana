class MenusController < ResourceController
  before_action :set_menu, only: %i[ show edit update destroy ]
  before_action :set_current_menu, only: :current_menu

  def current_menu
    if @current_menu.blank?
      respond_to do |format|
        format.html { redirect_to under_construction_path }
        format.json { render json: { error: 'No current menu found' }, status: :not_found }
      end

      return
    end

    respond_to do |format|
      format.html { render 'current_menu' }
      format.json { render json: @menu_items } 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu
      @menu = Menu.find(params[:id])
    end

    def set_current_menu
      @current_menu = Menu.find_by(currently_displayed: true)
      @menu_items = @current_menu.menu_items_for_display
    end

    # Only allow a list of trusted parameters through.
    def trusted_params
      params.require(:menu).permit(:name, :description, :text, :currently_displayed, menu_items_attributes: [:id, :item_id, :price, :_destroy])
    end
end
