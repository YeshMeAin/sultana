class GroceryListManager
  CACHE_KEY = "grocery_list"
  
  class << self
    def add_order(order)
      # Get products needed for this order
      products_needed = extract_products_from_order(order)
      
      # Get current grocery list
      grocery_list = get_list
      
      # Update quantities
      products_needed.each do |product_id, quantity|
        if grocery_list[product_id.to_s]
          grocery_list[product_id.to_s]["quantity"] += quantity
        else
          product = Product.find(product_id)
          grocery_list[product_id.to_s] = {
            "id" => product_id,
            "name" => product.name,
            "category" => product.category,
            "units" => product.units,
            "quantity" => quantity,
            "checked" => false
          }
        end
      end
      
      # Save updated list
      save_list(grocery_list)
    end
    
    def remove_order(order)
      # Get products needed for this order
      products_needed = extract_products_from_order(order)
      
      # Get current grocery list
      grocery_list = get_list
      
      # Update quantities
      products_needed.each do |product_id, quantity|
        if grocery_list[product_id.to_s]
          grocery_list[product_id.to_s]["quantity"] -= quantity
          
          # Remove product if quantity is zero or less
          if grocery_list[product_id.to_s]["quantity"] <= 0
            grocery_list.delete(product_id.to_s)
          end
        end
      end
      
      # Save updated list
      save_list(grocery_list)
    end
    
    def get_list
      Rails.cache.fetch(CACHE_KEY) { {} }
    end
    
    def save_list(list)
      Rails.cache.write(CACHE_KEY, list)
    end
    
    def update_item_status(product_id, checked)
      grocery_list = get_list
      
      if grocery_list[product_id.to_s]
        grocery_list[product_id.to_s]["checked"] = checked
        save_list(grocery_list)
        return true
      end
      
      false
    end
    
    def clear_list
      Rails.cache.delete(CACHE_KEY)
    end
    
    private
    
    def extract_products_from_order(order)
      products_needed = Hash.new(0)
      
      order.order_items.includes(item: { recipes: :product }).each do |order_item|
        order_item.item.recipes.each do |recipe|
          product = recipe.product
          required_quantity = product.adjusted_quantity(recipe.quantity) * order_item.quantity

          products_needed[product.id] += required_quantity
        end
      end
      
      products_needed
    end
  end
end 