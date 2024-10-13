Rails.application.routes.draw do
  resources :menus
  devise_for :users, skip: [:registrations]

  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'menus#current_menu', as: :unauthenticated_root
  end
 
  get "up" => "rails/health#show", as: :rails_health_check
end
