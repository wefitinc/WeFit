# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # Mount the action cable
  mount ActionCable.server => '/cable'

  # API
  namespace :api do
    namespace :v1 do
      post '/auth/signup', to: 'auth#signup'
      post '/auth/login', to: 'auth#login'
      get  '/auth/check', to: 'auth#check'
      get  '/auth/me', to: 'auth#me'
      post '/auth/upgrade', to: 'auth#upgrade'

      # TODO find a better routing for these
      get  '/users/:id/posts', to: 'posts#for_user'
      get  '/users/professionals', to: 'users#index_professionals'
      post '/users/:id/reset', to: 'users#reset'

      resources :users, only: [ :show, :destroy ] do
        get    'following', to: 'follows#index_following'
        get    'followers', to: 'follows#index_followers'

        post   'followers', to: 'follows#create'
        delete 'followers', to: 'follows#destroy'
        
        get    'reviews', to: 'reviews#index'
        post   'reviews', to: 'reviews#create'
      end

      post '/posts/filter', to: 'posts#filter'

      resources :posts, only: [ :index, :show, :create, :destroy ] do
        resources :views, only: [ :index, :create ]
        resources :likes, only: [ :index, :create ]
        resources :comments, only: [ :index, :create ]
      end

      post '/activities/filter', to: 'activities#filter'
      
      resources :activities, only: [ :index, :show, :create, :update, :destroy ] do
        resources :attendees, only: [ :index, :create ]
        delete '/attendees', to: 'attendees#destroy'
      end

      post '/groups/filter', to: 'groups#filter'

      resources :groups, only: [:index, :show, :create, :destroy ] do
        resources :members, only: [ :index, :create, :destroy ]
        resources :invites, only: [ :create ]
        resources :topics, only: [ :index, :create, :destroy ]
      end

      resources :topics, only: [:show, :destroy] do
        resources :likes, only: [ :index, :create ]
        resources :comments, only: [ :index, :create ]
      end

      delete '/posts/:post_id/likes', to: 'likes#destroy'
      delete '/topics/:topic_id/likes', to: 'likes#destroy'

      post  '/conversations/:conversation_id/messages/filter', to: 'messages#filter'

      resources :conversations, only: [:index, :create] do
        resources :messages, only: [:index, :create] 
      end
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
