Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

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


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
