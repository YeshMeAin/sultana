Rails.application.routes.draw do
  get 'pages/under_construction'
  devise_for :users, skip: [:registrations]

  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
    resources :orders
    resources :customers
    resources :products
    resources :items
    resources :menus
  end

  unauthenticated do
    root to: 'menus#current_menu', as: :unauthenticated_root
  end

  get '/under_construction', to: 'pages#under_construction', as: :under_construction
  
  get "up" => "rails/health#show", as: :rails_health_check
end
