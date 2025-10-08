Rails.application.routes.draw do
  resources :puzzles, only: [ :index, :edit, :update ] do
    resource :state, only: [ :update ], module: :puzzles
  end
  resources :sessions, only: [ :create, :destroy ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "/auth/:provider/callback", to: "sessions#create"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "puzzles#index"

  namespace :slack do
    post :new_puzzle, module: "slack", to: "commands#new_puzzle"
    post :puzzle, module: "slack", to: "puzzles#create"
  end
end
