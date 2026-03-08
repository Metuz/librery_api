Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    post '/login', to: 'auth#login'
    post '/logout', to: 'auth#logout'

    resources :books, only: [:index, :create, :update, :destroy]
    resources :borrowings, only: [:create] do
      patch '/return', on: :member, to: 'borrowings#return_book'
    end
    get '/dashboard', to: 'dashboard#index'
  end
end
