class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:following_id])
    return if current_user == @user

    current_user.follow(@user)
    @user.reload
    current_user.reload

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @user, notice: 'フォローしました' }
    end
  end

  def destroy
    @relationship = current_user.active_relationships.find_by(id: params[:id])

    if @relationship
      @user = @relationship.following
      @relationship.destroy
    else
      flash[:alert] = 'Relationship not found.'
      redirect_to root_path and return
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @user, notice: 'フォロー解除しました' }
    end
  end
end
