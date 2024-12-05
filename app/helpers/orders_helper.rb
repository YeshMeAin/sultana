module OrdersHelper
  def order_status_color(status)
    case status
    when 'pending'
      'bg-yellow-100 text-yellow-800'
    when 'confirmed'
      'bg-blue-100 text-blue-800'
    when 'preparing'
      'bg-purple-100 text-purple-800'
    when 'ready'
      'bg-green-100 text-green-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end
end
