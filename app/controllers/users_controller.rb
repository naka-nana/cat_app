class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:mypage]
  def show
    @user = User.find(params[:id])
  end

  def ensure_correct_user
    user = User.find_by(id: params[:id]) # `find_by` にして、nil の可能性を考慮

    return unless user.nil? || current_user != user

    redirect_to root_path, alert: 'アクセス権がありません'
  end

  def mypage
    @user = current_user
    @cats = @user.cats
  end
end
