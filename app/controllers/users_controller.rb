class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:mypage]

  def ensure_correct_user
    return unless current_user != User.find(params[:id])

    redirect_to root_path, alert: 'アクセス権がありません'
  end

  def mypage
    @user = current_user
    @cats = @user.cats
  end
end
