class CatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_cat, only: [:edit, :update, :destroy, :show] # `show` を追加
  before_action :set_form_data, only: [:new, :create]

  def index
    @cats = @user.cats
    render 'users/mypage'
  end

  def new
    @cat = @user.cats.new
  end

  def create
    @cat = @user.cats.build(cat_params) # `current_user.cats.build` でもOK
    if @cat.save
      redirect_to mypage_user_path(@user), notice: '猫が登録されました！'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:user_id])

    if params[:id] == 'diagnosis'
      @cat = @user.cats.first # まず1匹目の猫を選択
      redirect_to user_cat_diagnosis_path(@user, @cat) and return
    end

    @cat = @user.cats.find(params[:id])
  end

  def edit
    # `set_cat` に処理を任せるので、ここは不要
  end

  def update
    if @cat.update(cat_params)
      redirect_to mypage_user_path(@user), notice: '猫情報が更新されました！'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @cat.destroy
    redirect_to mypage_user_path(@user), notice: '猫情報が削除されました。'
  end

  private

  def set_user
    @user = User.find(params[:user_id] || params[:id])
  end

  def set_cat
    # 診断ページ (`/users/:user_id/cats/diagnosis`) の場合は `@cat` を設定しない
    return if params[:id] == 'diagnosis'

    @cat = @user.cats.find_by(id: params[:id])

    return if @cat

    redirect_to mypage_user_path(@user), alert: '猫が見つかりません。' and return
  end

  def set_form_data
    @ages = Age.all # 年齢カテゴリ
    @breeds = Breed.all # 品種カテゴリ
  end

  def cat_params
    params.require(:cat).permit(:name, :age_id, :breed_id, :image)
  end
end
