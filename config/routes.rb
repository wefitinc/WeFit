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

      resources :users, only: [ :show, :destroy ] do
        get    'following', to: 'follows#index_following'
        get    'followers', to: 'follows#index_followers'

        post   'followers', to: 'follows#create'
        delete 'followers', to: 'follows#destroy'
      end

      post '/posts/filter', to: 'posts#filter'

      resources :posts, only: [ :index, :show, :create, :destroy ] do
        resources :likes, only: [ :index, :create ]
        resources :views, only: [ :index, :create ]
        resources :comments, only: [ :index, :create ]
      end

      resources :activities, only: [ :index, :show, :create ]
    end
  end

  # Website
  # Password reset routing
  resources :password_resets, only: [:new, :create, :edit, :update]
  # Account activation routing
  resources :activations, only: [:new, :edit]
  # Static pages
  get 'about', to: 'static#about'
  get 'advertise', to: 'static#advertise'
  get 'professionals', to: 'static#professionals'
  # Root controller
  root 'static#home'
end
