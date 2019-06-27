# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get 'contact', :to => 'contact#index', :as => :contact
  get '/professionals', :to => 'professionals#index', :as => :professionals
  # Static page routing
  get '/about', :to => 'static#about', :as => :about
  get '/terms_of_use', :to => 'static#terms_of_use', :as => :terms_of_use
  get '/privacy_policy', :to => 'static#privacy_policy', :as => :privacy_policy
  # Session routing
  get '/login', :to => 'sessions#new', :as => :login
  get '/logout', :to => 'sessions#destroy'
  get '/auth/:provider/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'

  root 'welcome#index'
end
