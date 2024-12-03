class CustomersController < ResourceController
  before_action :set_customer, only: %i[ show edit update destroy ]

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def trusted_params
      params.require(:customer).permit(:name, :phone, :email, :address)
    end
end
