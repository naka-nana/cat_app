class CatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cat, only: [:edit, :update, :destroy]
  before_action :set_form_data, only: [:new, :create]
  def index
    @user = User.find(params[:id]) # この部分を確認
    @cats = @user.cats
    render 'users/mypage'
  end

  def new
    @user = User.find(params[:user_id])
    @cat = @user.cats.new
    @ages = Age.all
    @breeds = Breed.all
  end

  def create
    @cat = current_user.cats.build(cat_params)
    if @cat.save
      redirect_to new_user_cat_path(@user), notice: '猫が登録されました！'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:user_id])
    @cat = @user.cats.find(params[:id])
  end

  def edit
    @cat = @user.cats.find(params[:id])
  end

  def update
    if @cat.update(cat_params)
      redirect_to mypage_user_path(current_user), notice: '猫情報が更新されました！'
    else
      render :edit
    end
  end

  def destroy
    @cat.destroy
    redirect_to mypage_user_path(@user), notice: '猫情報が削除されました。'
  end

  private

  def set_cat
    @user = User.find_by(id: params[:user_id])
    redirect_to root_path, alert: 'ユーザーが見つかりません。' and return unless @user

    @cat = @user.cats.find_by(id: params[:id])
    return if @cat

    redirect_to user_mypage_path(@user), alert: '猫が見つかりません。' and return
  end

  def set_form_data
    @ages = Age.all # 年齢カテゴリ
    @breeds = Breed.all # 品種カテゴリ
  end

  def cat_params
    params.require(:cat).permit(:name, :age_id, :breed_id, :image)
  end
end
