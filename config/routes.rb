Rails.application.routes.draw do
  devise_for :users
  root "posts#index"
  resources :posts do
    resource :like, only: [:create, :destroy]  # 単一のいいねを管理
    resources :comments, only: [:create, :destroy]
  end  
  resources :users, only: [:show] do
    get 'diagnosis', to: 'diagnosis#select_cat', as: :select_diagnosis_cat
    post 'diagnosis/start', to: 'diagnosis#start', as: 'start_diagnosis'
    member do
      get 'mypage', to: 'cats#index', as: :mypage
    end

    resources :cats, only: [:new, :create, :show, :edit, :update, :destroy] do
      
      get 'diagnosis/question/:question_number', to: 'diagnosis#question', as: :question_diagnosis
      post 'diagnosis/answer/:question_number', to: 'diagnosis#answer', as: :answer_diagnosis
      get 'diagnosis/result', to: 'diagnosis#result', as: :result_diagnosis
    end
  end
end