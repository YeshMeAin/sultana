json.extract! order, :id, :customer_id, :due_date, :status, :created_at, :updated_at
json.url order_url(order, format: :json)
