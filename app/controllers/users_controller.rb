class UsersController < ApplicationController
  before_action :authenticate_user!

  def mypage
    @user = current_user
    @cats = @user.cats
  end
end
