Rails.application.routes.draw do
  get "like/toggle"
  get "/fandoms", to: "fandoms#index"

  devise_for :users 

  resources :profiles
  resources :trails

  #trails
  
  resources :trails, only: [:index, :show, :new, :edit, :destroy] do
    resource :comments
    get "/by_tag/:tag", to: "trails#by_tag", on: :collection, as: "tagged"
  end

  get 'likes/toggle/:trail_id', to: 'like#toggle', as: :toggle_like, defaults: { format: :json }

  #fandoms
  
  resources :fandoms, only: [:index, :show] do
    resource :trails do
      resources :comments, only: [:create]
    end
  end

  # admin
  
  namespace :admin do
    resources :fandoms
    resources :trails
    resources :comments
    resources :subscriptions
    resources :profiles
    resources :users
  end
  
  # api // v1

  namespace :api do
    namespace :v1 do
      resources :trails, only: [:index, :show, :destroy]
      resources :fandoms, only: [:index, :show]
      resources :users, only: [:index, :show] do
        resource :profile, only: [:show, :update]
      end
      resources :profiles, only: [:index, :show, :update, :destroy]

      get "profile", to: "users#profile"

      devise_scope :user do
        post "sign_in", to: "sessions#create"
        delete "sign_out", to: "sessions#destroy"
        post "sign_up", to: "registrations#create"
      end
    end
  end

  get '/trails/by_tag/:tag', to: 'trails#by_tag', as: :trails_by_tag
  
  get "base_pages/index"
  get "about", to: 'base_pages#about'
  # get "community", to: 'profiles#community'
  
  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  get '/profiles', to: 'profiles#index'
  
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "base_pages#index"
end



# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

# Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
# Can be used by load balancers and uptime monitors to verify that the app is live.