# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # API
  namespace :api do
    namespace :v1 do
      post '/auth/login', :to => 'auth#login'
      get  '/auth/check', :to => 'auth#check'
      get  '/auth/me', :to => 'auth#me'
      
      resources :users, only: [:show]
    end
  end

  # Website
  # Static page routing
  get '/about', :to => 'static#about', :as => :about
  get '/signup', :to => 'static#signup', :as => :signup
  get '/advertising', :to => 'static#advertising', :as => :advertising
  get '/terms_of_use', :to => 'static#terms_of_use', :as => :terms_of_use
  get '/professionals', :to => 'static#professionals', :as => :professionals
  get '/privacy_policy', :to => 'static#privacy_policy', :as => :privacy_policy
  # Contact routing
  get  '/contact', :to => 'contact#new', :as => :contact
  post '/send_contact', :to => 'contact#create', :as => :send_contact
  # Session routing
  post '/login', :to => 'sessions#create'
  get '/logout', :to => 'sessions#destroy'
  get '/auth/:provider/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'
  # User routing
  resources :users, only: [:create]
  # Password reset routing
  resources :password_resets, only: [:new, :create, :edit, :update]
  # Root controller
  root 'static#welcome'
end
