Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'consumptions#index'
  resources :consumptions, except: :show
  resources :tags, except: :show

  devise_for :users
  post '/users/sign_in/guest', to: 'guest#new'
  get '/guest/destroy', to: 'guest#destroy'

end
