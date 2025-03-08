Rails.application.routes.draw do
  get 'pages/under_construction'
  devise_for :users, skip: [:registrations]

  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
    
    resources :orders do
      post :confirm, on: :member
      post :prepare, on: :member
      post :ready, on: :member
      post :deliver, on: :member
      post :pay, on: :member
    end

    resources :customers
    resources :products
    resources :items
    resources :menus
    resources :categories

    # Dashboard routes
    get 'dashboard', to: 'dashboard#index'
    get 'generate_grocery_list', to: 'dashboard#generate_grocery_list'
    post 'update_grocery_item', to: 'dashboard#update_grocery_item'
    get 'refresh_grocery_list', to: 'dashboard#refresh_grocery_list'
    
    get 'current_menu', to: 'menus#current_menu', as: :current_menu
  end

  unauthenticated do
    root to: 'menus#current_menu', as: :unauthenticated_root
  end

  get '/under_construction', to: 'pages#under_construction', as: :under_construction

  get "up" => "rails/health#show", as: :rails_health_check
end
