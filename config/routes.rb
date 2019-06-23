Rails.application.routes.draw do
  # Static page routing
  get '/about', :to => 'about#index', :as => :about
  get '/professionals', :to => 'professionals#index', :as => :professionals
  # Session routing
  get '/login', :to => 'sessions#new', :as => :login
  match '/auth/:provider/callback', :to => 'sessions#create', :via => [:get, :post]
  get '/auth/failure', :to => 'sessions#failure'

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
