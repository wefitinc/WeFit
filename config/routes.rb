# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # API
  namespace :api do
    namespace :v1 do
      post '/auth/signup', to: 'auth#signup'
      post '/auth/login', to: 'auth#login'
      get  '/auth/check', to: 'auth#check'
      get  '/auth/me', to: 'auth#me'
      
      # TODO find a better routing for this
      get '/users/:id/posts', to: 'posts#for_user'

      resources :users, only: [:show] do
        get    'following', to: 'follows#index_following'
        get    'followers', to: 'follows#index_followers'
        
        post   'followers', to: 'follows#create'
        delete 'followers', to: 'follows#destroy'
      end
      resources :posts, only: [:index, :show, :create, :destroy] do
        resources :likes, only: [:index, :create]
        resources :comments, only: [:index, :create]
      end
    end
  end

  # Website
  # Static page routing
  get '/branding_assets', to: 'static#branding_assets'
  get '/advertising', to: 'static#advertising'
  get '/terms_of_use', to: 'static#terms_of_use'
  get '/privacy_policy', to: 'static#privacy_policy'
  get '/community_guidelines', to: 'static#community_guidelines'
  get '/cookie_policy', to: 'static#cookie_policy'
  get 'advertising_policy', to: 'static#advertising_policy'
  get 'what_is_we_fit', to: 'static#what_is_WeFit'
  get 'billing_page', to: 'static#billing_page'
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
  # Account activation routing
  resources :activations, only: [:new, :edit]
  # Professionals routing
  get  '/professionals', to: 'professionals#index'
  get  '/professionals/new/:rate', to: 'professionals#new'
  get  '/professionals/new/:rate/checkout', to: 'professionals#checkout'
  post '/professionals', to: 'professionals#create'
  # User routing
  get   'account_settings', to: 'users#edit'
  patch 'account_settings', to: 'users#update'
  # Root controller
  post '/', to: 'users#create'
  root 'users#new'
end
