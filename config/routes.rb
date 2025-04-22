Rails.application.routes.draw do
  # Authentication routes
  get "auth/sign_in"
  get "auth/register"

  # Scoped routes for localization (English and French)
  scope "(:locale)", locale: /en|fr/ do
    # Static pages
    get "contact", to: "pages#show", defaults: { slug: "contact" }, as: :contact
    get "about", to: "pages#show", defaults: { slug: "about" }, as: :about
    get "stores", to: "pages#stores", as: :stores
    get "services", to: "pages#services", as: :services

    # Cart routes
    get "cart", to: "carts#show", as: :cart
    post "cart/add", to: "carts#add", as: :add_to_cart
    delete "cart/remove", to: "carts#remove", as: :remove_from_cart

    # Checkout routes
    post "checkout/create", to: "checkout#create", as: :checkout_create
    get "checkout/success", to: "checkout#success", as: :checkout_success
    get "checkout/cancel", to: "checkout#cancel", as: :checkout_cancel

    # Search and Favourites routes
    get "search", to: "products#search", as: :search
    get "favourites", to: "favourites#index", as: :favourites

    # Products routes
    resources :products, only: [ :index, :show ] do
      collection do
        get :search
      end
    end

    # Address routes
    resource :address, only: [ :new, :create, :edit, :update ]

    # Favorites routes
    post "favorites/add", to: "favorites#add", as: :favorite_add

    # Organized Cart routes with shipping and checkout
    resources :carts, only: [ :show ] do
      collection do
        get :shipping, to: "carts#shipping", as: :shipping
        post :save_shipping, to: "carts#save_shipping", as: :save_shipping
        post :checkout, to: "carts#checkout", as: :checkout
      end
    end

    # Devise routes for users
    devise_for :users

    # Devise and ActiveAdmin routes for admin users
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)

    # Health check route
    get "up" => "rails/health#show", as: :rails_health_check

    # Root route
    root "products#index"
  end
end
