if Rails.env.development?
  User.create(email: 'admin@sultana.com', password: 'password')

  Menu.create(name: 'Winter 2024', currently_displayed: true)

  Item.create(name: 'Chicken Tikka Masala', description: 'Chicken cooked with tomatoes, onions, and spices', price: 14.99)
  Item.create(name: 'Lamb Vindaloo', description: 'Lamb cooked with vinegar, onions, and spices', price: 16.99)

  MenuItem.create(menu: Menu.first, item: Item.first)
  MenuItem.create(menu: Menu.first, item: Item.second)
end
