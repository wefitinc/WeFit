Rails.application.routes.draw do
    get 'privacy_policy/', :to => 'privacy_policy#index', :as => :privacy_policy
  # Static page routing
  get '/about', :to => 'about#index', :as => :about
  get '/professionals', :to => 'professionals#index', :as => :professionals
  # Session routing
  get '/login', :to => 'sessions#new', :as => :login
  get '/logout', :to => 'sessions#destroy'
  get '/auth/:provider/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
