# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :users, only: [:show] do
    # get 'discover', on: :member
    resources :discover, only: [:index], controller: 'user/discover'
  end
end
