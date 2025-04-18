Rails.application.routes.draw do
  # Static pages
  get "contact", to: "pages#show", defaults: { slug: "contact" }, as: :contact
  get "about", to: "pages#show", defaults: { slug: "about" }, as: :about
  get 'stores', to: 'pages#stores', as: :stores
  get 'services', to: 'pages#services', as: :services
  get 'cart', to: 'carts#show', as: :cart

  # Products routes
  resources :products, only: [:index, :show]

  # Devise and ActiveAdmin routes
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route
  root "products#index"
end