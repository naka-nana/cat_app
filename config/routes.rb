Rails.application.routes.draw do
  get 'cats/new'
  get 'cats/create'
  devise_for :users
  resources :users do
    resources :cats, only: [:new, :create]
    resources :users, only: [:show]
  end
  
  resources :posts do
    resources :users, only: [:edit, :update,:show]
  end
end
