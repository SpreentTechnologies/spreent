Rails.application.routes.draw do
  devise_for :users, path: '',
    controllers: { registrations: "users/registrations" },
    path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "splash#index"

  get '/home', to: 'about#index'

  get '/invite', to: 'invitation_codes#verify'
  post '/invite', to: 'invitation_codes#check'
  resources :invitation_codes, only: [:create, :destroy]

  get '/feed', to: 'feed#index'
  get '/messages', to: 'messages#index'
  get '/messages/:id', to: 'messages#show'

  # Communities
  get '/communities', to: 'communities#index', as: 'communities'
  get '/communities/:id', to: 'communities#show'
  delete '/communities/:id', to: 'communities#destroy'

  get '/notifications', to: 'notifications#index'

  post '/posts', to: 'posts#create'

  get '/admin', to: 'admin#index', as: 'admin'

  # User profile
  get '/profile', to: 'profile#index', as: 'profile'
  get '/profile/:id', to: 'profile#show'
end
