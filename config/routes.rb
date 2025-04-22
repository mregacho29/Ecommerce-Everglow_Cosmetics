Rails.application.routes.draw do
  get "auth/sign_in"
  get "auth/register"
  scope "(:locale)", locale: /en|fr/ do
    get "favourites/index"
    get "carts/show"

    # Static pages
    get "contact", to: "pages#show", defaults: { slug: "contact" }, as: :contact
    get "about", to: "pages#show", defaults: { slug: "about" }, as: :about
    get "stores", to: "pages#stores", as: :stores
    get "services", to: "pages#services", as: :services

    get "cart", to: "carts#show", as: :cart
    post "cart/add", to: "carts#add", as: :add_to_cart
    delete "cart/remove", to: "carts#remove", as: :remove_from_cart


    post "checkout/create", to: "checkout#create", as: :checkout_create
    get "checkout/success", to: "checkout#success", as: :checkout_success
    get "checkout/cancel", to: "checkout#cancel", as: :checkout_cancel


    get "search", to: "products#search", as: :search
    get "favourites", to: "favourites#index", as: :favourites

    # Products routes
    resources :products, only: [ :index, :show ] do
      collection do
        get :search
      end
    end

    resource :cart, only: [ :show ] do
      patch :update_quantity, to: "carts#update_quantity"
      delete :remove, to: "carts#remove"
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
