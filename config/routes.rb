Rails.application.routes.draw do
  devise_for :users 
  

  resources :trails, only: [:index, :show] do
    resource :comments
  end
  
  resources :welcomes
  resources :subscriptions, only: [:create]
  resources :comments, only: [:create]

  namespace :admin do
    resources :fandoms
    resources :trails do
      delete :destroy, on: :member
    end
    resources :subscriptions
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  get "welcomes/index"
  get 'about', to: 'welcomes#about', as: :about 

  # Defines the root path route ("/")
  root "welcomes#index"
end
