Rails.application.routes.draw do
  devise_for :users
  root "posts#index"
  get 'posts/index'
  resources :users, only: [] do
    member do
      get 'mypage', to: 'cats#index', as: :mypage
    end
    resources :cats, only: [:new, :create, :show, :edit, :update, :destroy]
  end
end
