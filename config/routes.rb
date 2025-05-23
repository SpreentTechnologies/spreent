Rails.application.routes.draw do
  root "splash#index"
  
  devise_for :users, path: "",
    controllers: { 
      registrations: "users/registrations", 
      omniauth_callbacks: "users/omniauth_callbacks" ,
      passwords: "passwords"
    },
    path_names: { 
      sign_in: "login", 
      sign_out: "logout", 
      sign_up: "register" 
    },
    class_name: "User"

  get "up" => "rails/health#show", as: :rails_health_check

  get '/.well-known/appspecific/com.chrome.devtools.json', to: proc { [200, { 'Content-Type' => 'application/json' }, ['{}']] }

  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  get "/home", to: "about#index", as: :home

  get "/invite", to: "invitation_codes#verify"
  post "/invite", to: "invitation_codes#check"
  resources :invitation_codes, only: [:create, :destroy]

  get "/feed", to: "feed#index", as: :feed

  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  # Communities
  resources :communities, only: [:index, :show, :update] do
    member do
      post "join"
      delete "leave"
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
  get "/notifications/communities", to: "notifications#communities", as: :communities_notifications
  get "/notifications/challenges", to: "notifications#challenges", as: :challenges_notifications

  resource :avatar, only: [:update, :destroy]
  resource :settings, only: [:show, :update]

  post "/posts", to: "posts#create"

  get "/admin", to: "admin#index", as: "admin"

  resources :challenges, only: [:create, :show] do
    post "join", on: :member
    post "invite", on: :member
  end

  # User profile
  get "/profile", to: "profile#index", as: "profile"
  get "/profile/:id", to: "profile#show", as: "user_profile"

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
      post "follow", to: "follows#create", as: :follow
      delete "unfollow", to: "follows#destroy", as: :unfollow
    end
  end

  get "/search", to: "search#index", as: :search

  mount ActionCable.server => "/cable"

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  post "/profile", to: "profile#update", as: :update_profile

    if Rails.env.production?
      Sidekiq::Web.use Rack::Auth::Basic do |username, password|
        ActiveSupport::SecurityUtils.secure_compare(username, ENV["SIDEKIQ_USERNAME"]) &
        ActiveSupport::SecurityUtils.secure_compare(password, ENV["SIDEKIQ_PASSWORD"])
      end
    end

    mount Sidekiq::Web => '/sidekiq'
end
