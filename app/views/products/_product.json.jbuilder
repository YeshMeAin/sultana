json.extract! product, :id, :name, :units, :price_per_unit, :in_bulk, :created_at, :updated_at
json.url product_url(product, format: :json)
