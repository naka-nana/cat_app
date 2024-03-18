class CatsController < ApplicationController
  before_action :set_user

  def new
    @cat = Cat.new
  end

  def create
    @cat = @user.cats.build(cat_params)
    if @cat.save
      redirect_to user_path(@user), notice: '猫を登録しました。'
    else
      render :new
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def cat_params
    params.require(:cat).permit(:name, :age_id, :birthday, :breed_id, :color_id)
  end
end
