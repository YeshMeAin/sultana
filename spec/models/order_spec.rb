require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:customer) { create(:customer) }
  let(:item) { create(:item) }
  let(:order) { create(:order, customer: customer) }

  describe 'associations' do
    it { should belong_to(:customer) }
    it { should have_many(:order_items).dependent(:destroy) }
    it { should have_many(:items).through(:order_items) }
    it { should accept_nested_attributes_for(:order_items).allow_destroy(true) }
  end

  describe 'callbacks' do
    describe '#update_grocery_list' do
      let(:order_with_items) { create(:order, :with_custom_items, status: :pending, customer: customer) }

      before do
        allow(GroceryListManager).to receive(:add_order)
        allow(GroceryListManager).to receive(:remove_order)
      end

      it 'adds to grocery list when status changes to confirmed' do
        expect(GroceryListManager).to receive(:add_order)
        order_with_items.update(status: :confirmed)
      end
      
      it 'removes from grocery list when status changes from confirmed' do
        order_with_items.update(status: :confirmed)
        expect(GroceryListManager).to receive(:remove_order)
        order_with_items.update(status: :preparing)
      end
      
      it 'does not update grocery list when status does not change' do
        order_with_items.update(status: :confirmed)
        expect(GroceryListManager).not_to receive(:add_order)
        expect(GroceryListManager).not_to receive(:remove_order)
        order_with_items.update(due_date: 1.day.from_now)
      end
    end
  end

  describe 'scopes' do
    before do
      @old_order = create(:order, customer: customer, created_at: 2.days.ago)
      @new_order = create(:order, customer: customer, created_at: 1.hour.ago)
      @paid_order = create(:order, customer: customer, status: :paid)
      @pending_order = create(:order, customer: customer, status: :pending)
      @cancelled_order = create(:order, customer: customer, status: :cancelled)
    end
    
    describe '.since' do
      it 'returns orders created after the given date' do
        result = Order.since(1.day.ago)
        expect(result).to include(@new_order)
        expect(result).not_to include(@old_order)
      end
    end
    
    describe '.open_orders' do
      it 'returns orders that are not paid' do
        result = Order.open_orders
        expect(result).to include(@pending_order)
        expect(result).not_to include(@paid_order)
        expect(result).not_to include(@cancelled_order)
      end
      
      it 'orders results by created_at descending' do
        result = Order.open_orders
        expect(result.first.created_at).to be > result.last.created_at
      end
    end
  end

  describe 'state machine' do
    it 'has initial state of pending' do
      expect(order.status).to eq('pending')
    end
    
    describe 'transitions' do
      it 'transitions from pending to confirmed' do
        expect { order.confirm! }.to change { order.status }.from('pending').to('confirmed')
      end
      
      it 'transitions from confirmed to preparing' do
        order.update(status: :confirmed)
        expect { order.prepare! }.to change { order.status }.from('confirmed').to('preparing')
      end
      
      it 'transitions from preparing to ready' do
        order.update(status: :preparing)
        expect { order.ready! }.to change { order.status }.from('preparing').to('ready')
      end
      
      it 'transitions from ready to delivered' do
        order.update(status: :ready)
        expect { order.deliver! }.to change { order.status }.from('ready').to('delivered')
      end
      
      it 'transitions from delivered to paid' do
        order.update(status: :delivered)
        expect { order.pay! }.to change { order.status }.from('delivered').to('paid')
      end
      
      it 'transitions from pending to cancelled' do
        expect { order.cancel! }.to change { order.status }.from('pending').to('cancelled')
      end
      
      it 'transitions from confirmed to cancelled' do
        order.update(status: :confirmed)
        expect { order.cancel! }.to change { order.status }.from('confirmed').to('cancelled')
      end
      
      it 'raises error for invalid transitions' do
        order.update(status: :preparing)
        expect { order.cancel! }.to raise_error(AASM::InvalidTransition)
      end
    end
  end

  describe 'class methods' do
    describe '.table_attributes' do
      it 'returns the correct attributes' do
        expect(Order.table_attributes).to eq([:customer_name, :status, :due_date, :total_price])
      end
    end
    
    describe '.show_attributes' do
      it 'returns the correct attributes' do
        expect(Order.show_attributes).to eq([:customer_name, :customer_phone, :status, :created_at, :due_date, :updated_at])
      end
    end
    
    describe '.average_total_price' do
      before do
        @order1 = create(:order, :with_custom_items, created_at: 20.hours.ago, customer: customer, items_attributes: [{ quantity: 1, price: 10.0 }, { quantity: 1, price: 20.0 }])
        @order2 = create(:order, :with_custom_items, created_at: 3.days.ago, customer: customer, items_attributes: [{ quantity: 2, price: 10.0 }, { quantity: 2, price: 20.0 }])
      end
      
      it 'calculates the average total price of orders' do
        @order1.reload
        @order2.reload
                
        expect(Order.average_total_price).to eq(45)
      end
      
      it 'filters by date when since parameter is provided' do
        @order2.update(created_at: 2.days.ago)
        
        expect(Order.average_total_price(since: 1.day.ago)).to eq(30.0)
      end
      
      it 'returns 0 when no orders match' do
        Order.destroy_all
        expect(Order.average_total_price).to eq(0)
      end
    end
  end

  describe 'instance methods' do
    before do
      @order = create(:order, :with_custom_items, customer: customer, items_attributes: [{ quantity: 2, price: 10.0 }, { quantity: 1, price: 20.0 }])
    end
    
    describe '#associated_collections' do
      it 'returns order items with correct attributes' do
        collections = @order.associated_collections
        expect(collections.size).to eq(1)
        expect(collections.first[:name]).to eq('Order Items')
        expect(collections.first[:collection]).to be_present
      end
    end
    
    describe '#total_price' do
      it 'calculates the total price of all order items' do
        # 2 * 10 + 1 * 20 = 40
        expect(@order.total_price).to eq(40.0)
      end
    end
    
    describe '#customer_name' do
      it 'returns the customer name' do
        expect(@order.customer_name).to eq(@order.customer.name)
      end
    end
    
    describe '#customer_phone' do
      it 'returns the customer phone' do
        expect(@order.customer_phone).to eq(@order.customer.phone)
      end
    end
  end
end
