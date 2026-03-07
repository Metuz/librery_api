Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    post '/login', to: 'auth#login'
    post '/logout', to: 'auth#logout'

    resources :books, only: [:index, :create, :update, :destroy]
  end
end
