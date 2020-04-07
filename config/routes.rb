Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'guest#new'
  resources :consumptions, except: :show
  resources :tags, except: :show do
    patch 'sort', on: :member
  end

  get '/users/sign_up', to: 'users#new'
  post '/users', to: 'users#create'

  namespace :users do
    resource :passwords, only: [:new, :create, :edit, :update]
  end

  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  delete '/sign_out', to: 'sessions#destroy'

  post '/sign_in/guest', to: 'guest#new', as: :sign_in_guest
end
