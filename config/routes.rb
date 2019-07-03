# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get 'contact', :to => 'contact#index', :as => :contact
  get '/professionals', :to => 'professionals#index', :as => :professionals
  # Static page routing
  get '/about', :to => 'static#about', :as => :about
  get '/ad_manager', :to => 'static#ad_manager', :as => :ad_manager
  get '/terms_of_use', :to => 'static#terms_of_use', :as => :terms_of_use
  get '/privacy_policy', :to => 'static#privacy_policy', :as => :privacy_policy
  # Session routing
  post '/signup', :to => 'sessions#new'
  get '/logout', :to => 'sessions#destroy'
  get '/auth/:provider/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'
  # Root controller
  root 'welcome#index'
end
