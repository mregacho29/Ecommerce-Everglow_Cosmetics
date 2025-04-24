Rails.application.routes.draw do
  get "home/index"
  get "orders/index"
  get "orders/show"
  # Category routes
  get "categories/show"

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
    # Ensure these routes point to the correct controller (CartsController)
    get "cart", to: "carts#show", as: :cart # Displays the cart
    post "cart/add", to: "carts#add", as: :cart_add # Adds an item to the cart
    delete "cart/remove", to: "carts#remove", as: :remove_from_cart # Removes an item from the cart

    # Checkout routes
    post "checkout/create", to: "checkout#create", as: :checkout_create
    get "checkout/success", to: "checkout#success", as: :checkout_success
    get "checkout/cancel", to: "checkout#cancel", as: :checkout_cancel

    # Search and Favourites routes
    get "search", to: "products#search", as: :search

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
    get "favorites", to: "favorites#index", as: :favorites
    resources :favorites, only: [ :index ] do
      member do
        delete :remove, to: "favorites#remove", as: :remove
      end
    end

    # Organized Cart routes with shipping and checkout
    resources :carts, only: [ :show ] do
      collection do
        get :shipping, to: "carts#shipping", as: :shipping
        post :save_shipping, to: "carts#save_shipping", as: :save_shipping
        post :checkout, to: "carts#checkout", as: :checkout
      end
    end

    # Category routes
    resources :categories, only: [ :show ]

    # Order routes
    resources :orders, only: [ :index, :show ] # For customers
    namespace :admin do
      resources :orders, only: [ :index, :show ] # For admins
    end

    # Home routes
    resources :announcements, only: [ :index, :show ]


    # Devise routes for users
    devise_for :users

    # Devise and ActiveAdmin routes for admin users
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)

    # Health check route
    get "up" => "rails/health#show", as: :rails_health_check

    # Root route
    root "home#index"
  end
end
