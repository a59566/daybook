Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'guest#new'
  resources :consumptions, except: :show
  resources :tags, except: :show do
    patch 'sort', on: :member
  end

  devise_for :users
  post '/users/sign_in/guest', to: 'guest#new'
end
