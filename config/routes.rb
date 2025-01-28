Rails.application.routes.draw do
  devise_for :users
  root "posts#index"
  get 'posts/index'
  resources :users, only: [] do
    member do
      get 'mypage', to: 'cats#index', as: :mypage
    end
    resources :cats, only: [:new, :create, :show, :edit, :update, :destroy]
    collection do
      get 'diagnosis', to: 'diagnosis#new'    # 診断フォーム
      post 'diagnosis', to: 'diagnosis#result' # 診断結果
    end
  end
end
