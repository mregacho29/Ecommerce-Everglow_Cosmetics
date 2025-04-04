Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :products, only: [:index, :show] # Add this line for products
  resources :categories, only: [:index, :show] # Add this line for categories
  resources :orders, only: [:new, :create] # Add this line for orders
  resources :cart, only: [:show] # Add this line for cart
  resources :users, only: [:new, :create] # Add this line for users
  resources :sessions, only: [:new, :create, :destroy] # Add this line for sessions
  resources :addresses, only: [:new, :create] # Add this line for addresses


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
