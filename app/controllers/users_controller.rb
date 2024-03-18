class UsersController < ApplicationController

  def edit
  end

  def show
    @user = User.find(params[:id])
    @cats = @user.cats
  end
  private

  def set_prefectures
    @prefectures = Prefecture.all
  end
end
