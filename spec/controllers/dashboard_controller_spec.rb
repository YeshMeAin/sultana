require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) { create(:user) }
  
  before do
    sign_in user
  end

  describe "GET #index" do
    before do
      allow(Order).to receive(:where).and_return([])
      allow(Order).to receive(:average_total_price).and_return(25.0)
      allow(Order).to receive(:open_orders).and_return([])
    end

    it "assigns @payed_this_month" do
      orders = [double(total_price: 10), double(total_price: 20)]
      allow(Order).to receive(:where).with(
        status: :payed,
        created_at: Time.current.beginning_of_month..Time.current.end_of_month
      ).and_return(orders)

      get :index
      expect(assigns(:payed_this_month)).to eq(30)
    end

    it "assigns @orders_count_this_month" do
      orders = [double(total_price: 10), double(total_price: 20)]
      allow(Order).to receive(:since).with(Time.current.beginning_of_month).and_return(orders)
      get :index

      expect(assigns(:orders_count_this_month)).to eq(2)
    end

    it "assigns @average_order_value" do
      get :index
      expect(assigns(:average_order_value)).to eq(25.0)
    end

    it "assigns @open_orders" do
      open_orders = [create(:order)]
      allow(Order).to receive(:open_orders).and_return(open_orders)
      
      get :index
      expect(assigns(:open_orders)).to eq(open_orders)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #generate_grocery_list" do
    let(:grocery_list) { { "1" => { "name" => "Tomatoes", "category" => "Vegetables" } } }
    let(:formatted_list) { [{ "name" => "Tomatoes", "category" => "Vegetables" }] }

    before do
      allow(GroceryListManager).to receive(:get_list).and_return(grocery_list)
    end

    it "returns JSON response" do
      get :generate_grocery_list, format: :json
      expect(response.content_type).to include('application/json')
      expect(JSON.parse(response.body)).to eq(formatted_list)
    end
    
    it "returns 406 for HTML request" do
      get :generate_grocery_list
      expect(response.status).to eq(406) # Not Acceptable
    end
  end

  describe "POST #update_grocery_item" do
    it "updates the item status and returns success true when successful" do
      allow(GroceryListManager).to receive(:update_item_status).with("123", true).and_return(true)
      
      post :update_grocery_item, params: { product_id: "123", checked: "true" }, format: :json
      
      expect(response.content_type).to include('application/json')
      expect(JSON.parse(response.body)).to eq({ "success" => true })
    end

    it "returns success false when update fails" do
      allow(GroceryListManager).to receive(:update_item_status).with("123", false).and_return(false)
      
      post :update_grocery_item, params: { product_id: "123", checked: "false" }, format: :json
      
      expect(response.content_type).to include('application/json')
      expect(JSON.parse(response.body)).to eq({ "success" => false })
    end
  end

  describe "GET #refresh_grocery_list" do
    let(:confirmed_orders) { [create(:order, status: :confirmed), create(:order, status: :confirmed)] }
    
    before do
      allow(Order).to receive(:where).with(status: :confirmed).and_return(confirmed_orders)
      allow(GroceryListManager).to receive(:clear_list)
      allow(GroceryListManager).to receive(:add_order)
    end

    it "clears the grocery list" do
      expect(GroceryListManager).to receive(:clear_list)
      get :refresh_grocery_list
    end

    it "adds each confirmed order to the grocery list" do
      confirmed_orders.each do |order|
        expect(GroceryListManager).to receive(:add_order).with(order)
      end
      
      get :refresh_grocery_list
    end

    it "redirects to generate_grocery_list_path with notice" do
      get :refresh_grocery_list
      
      expect(response).to redirect_to(generate_grocery_list_path)
      expect(flash[:notice]).to eq("Grocery list has been refreshed")
    end
  end

  describe "#format_grocery_list" do
    it "formats the grocery list hash into a sorted array" do
      grocery_list = {
        "1" => { "name" => "Tomatoes", "category" => "Vegetables" },
        "2" => { "name" => "Apples", "category" => "Fruits" },
        "3" => { "name" => "Bread", "category" => nil }
      }
      
      expected_result = [
        { "name" => "Bread", "category" => nil },
        { "name" => "Apples", "category" => "Fruits" },
        { "name" => "Tomatoes", "category" => "Vegetables" }
      ]
      
      # Call the private method
      result = controller.send(:format_grocery_list, grocery_list)
      
      # Sort both arrays the same way to compare them regardless of order
      sorted_result = result.sort_by { |item| [item["category"] || "", item["name"]] }
      sorted_expected = expected_result.sort_by { |item| [item["category"] || "", item["name"]] }
      
      expect(sorted_result).to eq(sorted_expected)
    end
  end
end
