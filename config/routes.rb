Rails.application.routes.draw do
  devise_for :users, path: '',
    controllers: { registrations: "users/registrations" },
    path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" }

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "splash#index"

  get '/home', to: 'about#index'

  get '/invite', to: 'invitation_codes#verify'
  post '/invite', to: 'invitation_codes#check'
  resources :invitation_codes, only: [:create, :destroy]

  get '/feed', to: 'feed#index'

  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  # Communities
  resources :communities, only: [:index, :show, :update] do
    member do
      post 'join'
      delete 'leave'
    end

    resources :challenges
  end

  resources :notifications, only: [:index] do
    member do
      post :mark_as_read
    end
    collection do
      post :mark_all_as_read
    end
  end

  resource :avatar, only: [:update, :destroy]
  resource :settings, only: [:show, :update]

  post '/posts', to: 'posts#create'

  get '/admin', to: 'admin#index', as: 'admin'

  resources :challenges, only: [:create, :show] do
    post 'join', on: :member
    post 'invite', on: :member
  end

  # User profile
  get '/profile', to: 'profile#index', as: 'profile'
  get '/profile/:id', to: 'profile#show'

  resources :posts do
    resources :comments, only: [:index, :create, :destroy]
    resource :like, only: [:create, :destroy]
    resources :reports, only: [:new, :create]
  end

  resources :categories, only: [:index] do
    resources :sports, only: [:create] do
      resources :communities, only: [:index, :new, :create]
    end
  end

  resources :calls, only: [:create] do
    member do
      patch :accept
      patch :end
    end
  end

  resources :users, only: [:show, :index] do
    member do
      post 'follow', to: 'follows#create', as: :follow
      delete 'unfollow', to: 'follows#destroy', as: :unfollow
    end
  end

  get '/search', to: 'search#index'

  mount ActionCable.server => '/cable'
end
