Rails.application.routes.draw do
  devise_for :users
  root "posts#index"
  get 'posts/index'
  resources :users, only: [] do
    member do
      get 'mypage', to: 'users#mypage'
    end
  end
  
  resources :cats
end
