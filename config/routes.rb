# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: 'home#index'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login_user'

  resources :users, only: [:show] do
    resources :discover, only: [:index], controller: 'user/discover'
    resources :movies, only: [:index, :show], controller: 'user/movies' do
      resources :viewing_parties, path: '/viewing-party', only: [:new, :create], controller: 'user/movie/viewing_parties'
    end
  end
end
