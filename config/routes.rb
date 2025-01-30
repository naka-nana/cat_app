Rails.application.routes.draw do
  devise_for :users
  root "posts#index"
  get 'posts/index'

  resources :users, only: [] do
    get 'diagnosis', to: 'diagnosis#select_cat', as: :select_diagnosis_cat
    member do
      get 'mypage', to: 'cats#index', as: :mypage
    end
  end
end