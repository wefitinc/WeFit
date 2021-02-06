# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # Mount the action cable
  mount ActionCable.server => '/cable'

  # API
  namespace :api do
    namespace :v1 do
      post  '/auth/signup', to: 'auth#signup'
      post  '/auth/login', to: 'auth#login'
      get   '/auth/check', to: 'auth#check'
      get   '/auth/me', to: 'auth#me'
      patch '/auth/me', to: 'auth#update'
      post  '/auth/upgrade', to: 'auth#upgrade'

      # TODO find a better routing for these
      get  '/users/:id/posts', to: 'posts#for_user'
      get  '/users/professionals', to: 'users#index_professionals'
      post '/users/:id/reset', to: 'users#reset'

      resources :users, only: [ :show, :destroy ] do
        collection do
          get 'suggestions'
          get 'professionals_suggestions'
          post 'search_professionals'
          post 'search'
        end

        member do
          get 'groups'
        end
        get    'following', to: 'follows#index_following'
        get    'followers', to: 'follows#index_followers'
        get    'friends', to: 'follows#index_friends'

        post   'followers', to: 'follows#create'
        delete 'followers', to: 'follows#destroy'

        get    'reviews', to: 'reviews#index'
        post   'reviews', to: 'reviews#create'
      end

      resources :professionals, only: [ :index, :show ] do
        collection do 
          post 'signup'
        end
      end

      post '/posts/filter', to: 'posts#filter'

      resources :posts, only: [ :index, :show, :create, :destroy ] do
        collection do
          get 'category_top_posts'
          get 'category_posts'
          post 'rewatch'
          get 'taggable_users'
          post 'search_taggable_user'
          get 'categories'
        end
        resources :views, only: [ :index, :create ]
        resources :likes, only: [ :index, :create ]
        resources :reports, only: [ :index, :create ]
        resources :comments, only: [ :index, :create, :destroy ]
      end

      post '/activities/filter', to: 'activities#filter'

      resources :activities, only: [ :index, :show, :create, :update, :destroy ] do
        collection do
          get 'suggestions'
          post 'search'
        end
        resources :reports, only: [ :index, :create ]
        resources :participants, only: [ :index, :create ] do
          collection do
            get 'attendees'
          end
        end
      end

      post '/groups/filter', to: 'groups#filter'

      resources :groups, only: [:index, :show, :create, :destroy ] do
        collection do
          get 'suggestions'
          post 'search'
        end
        member do 
          post 'leave'
        end
        resources :admins, only: [ :index, :create ] do
          collection do 
            post 'remove'
          end
        end
        resources :members, only: [ :index, :create ]
        resources :invites, only: [ :create ]
        resources :requests, only: [ :index, :create ] do 
          collection do 
            post 'reject'
          end
          member do
            post 'accept'
          end
        end
        resources :reports, only: [ :index, :create ]
        resources :topics, only: [ :index, :create, :destroy ]
      end

      resources :topics, only: [:show, :destroy] do
        resources :likes, only: [ :index, :create, :destroy ]
        resources :comments, only: [ :index, :create, :destroy ]
        resources :reports, only: [ :index, :create ]
      end

      resources :comments, only: [ :index, :create, :destroy ] do
        resources :reports, only: [ :index, :create ]
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
  # Contact routing
  post 'contact', to: 'contact#create'
  # Static pages
  get 'help', to: 'contact#new'
  get 'privacy', to: 'static#privacy'
  get 'terms', to: 'static#terms'
  # Root controller
  root 'static#home'
end
