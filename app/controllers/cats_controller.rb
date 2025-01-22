class CatsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_cat, only: [:edit, :update, :destroy]
  before_action :set_form_data, only: [:new, :create]
  def new
    @cat = Cat.new
    @ages = Age.all
    @breeds = Breed.all
  end

  def create
    @cat = current_user.cats.build(cat_params)
    if @cat.save
      redirect_to new_cat_path, notice: '猫が登録されました！'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # def show
  # end

  # def edit
  #   @ages = Age.all
  #   @breeds = Breed.all
  # end

  # def update
  #   if @cat.update(cat_params)
  #     redirect_to mypage_user_path(current_user), notice: '猫情報が更新されました！'
  #   else
  #     render :edit
  #   end
  # end

  # def destroy
  #   @cat.destroy
  #   redirect_to mypage_user_path(current_user), notice: '猫情報が削除されました。'
  # end

  private

  def set_cat
    @cat = current_user.cats.find(params[:id])
  end

  def set_form_data
    @ages = Age.all # 年齢カテゴリ
    @breeds = Breed.all # 品種カテゴリ
  end

  def cat_params
    params.require(:cat).permit(:name, :age_id, :breed_id)
  end
end
