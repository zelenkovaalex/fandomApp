Rails.application.routes.draw do
  get "like/toggle"
  get "/fandoms", to: "fandoms#index"

  resources :profiles
  resources :trails

  devise_for :users 
  
  #trails
  
  resources :trails, only: [:index, :show, :new, :edit, :destroy] do
    resource :comments
    get "/by_tag/:tag", to: "trails#by_tag", on: :collection, as: "tagged"
  end

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
      resources :profiles, only: [:index, :show]
      post 'sessions', to: 'sessions#create'

      devise_scope :user do
        scope 'sessions' do
          post "sign_in", to: "sessions#create"
          post "sign_out", to: "sessions#destroy"
          get "info", to: "sessions#show"
        end
      end

    end
  end


  
  get "base_pages/index"
  get "about", to: 'base_pages#about'
  # get "community", to: 'profiles#community'
  
  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "base_pages#index"
end



# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

# Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
# Can be used by load balancers and uptime monitors to verify that the app is live.