class UsersController < ApplicationController

  def edit
  end
  private

  def set_prefectures
    @prefectures = Prefecture.all
  end
end
