# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # API
  namespace :api do
    namespace :v1 do
      post '/auth/signup', to: 'auth#signup'
      post '/auth/login', to: 'auth#login'
      get  '/auth/check', to: 'auth#check'
      get  '/auth/me', to: 'auth#me'
      
      resources :users, only: [:show]
    end
  end

  # Website
  # Static page routing
  get '/about', to: 'static#about'
  get '/branding_assets', to: 'static#branding_assets'
  get '/advertising', to: 'static#advertising'
  get '/account_help', to: 'static#account_help'
  get '/terms_of_use', to: 'static#terms_of_use'
  get '/professionals', to: 'static#professionals'
  get '/privacy_policy', to: 'static#privacy_policy'
  get '/community_guidelines', to: 'static#community_guidelines'
  get '/cookie_policy', to: 'static#cookie_policy'
  get 'advertising_policy', to: 'static#advertising_policy'
  # Contact routing
  get  '/contact', to: 'contact#new'
  post '/contact', to: 'contact#create'
  # Session routing
  post '/login', to: 'sessions#create'
  get  '/logout', to: 'sessions#destroy'
  get  '/auth/:provider/callback', to: 'sessions#create'
  get  '/auth/failure', to: 'sessions#failure'
  # Password reset routing
  resources :password_resets, only: [:new, :create, :edit, :update]
  # Root controller
  post '/', to: 'welcome#create'
  root 'welcome#index'
end
