Rails.application.routes.draw do
  get "auth/sign_in"
  get "auth/register"
  scope "(:locale)", locale: /en|fr/ do
    get "favourites/index"
    get "carts/show"

  resources :products, only: [ :index, :show ]
  resources :categories, only: [ :index, :show ]
  resources :orders, only: [ :new, :create, :show ]
  resources :cart, only: [ :show ]
  resources :users, only: [ :new, :create ]
  resources :sessions, only: [ :new, :create, :destroy ]
  resources :addresses, only: [ :new, :create ]
  resources :payments, only: [] do
    member do
      put :confirm
    end
  end

    # Products routes
    resources :products, only: [ :index, :show ] do
      collection do
        get :search
      end
    end

    devise_for :users

    # Devise and ActiveAdmin routes
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)

    # Health check route
    get "up" => "rails/health#show", as: :rails_health_check

    # Root route
    root "products#index"
  end
end
