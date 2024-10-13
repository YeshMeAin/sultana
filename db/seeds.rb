if Rails.env.development?
  User.create(email: 'admin@sultana.com', password: 'password')
end
