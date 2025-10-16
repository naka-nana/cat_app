class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    # どちらのパラメータ形式にも対応（テスト/画面の両方OK）
    target_id = params.dig(:relationship, :followed_id) || params[:followed_id]
    @user = User.find(target_id)

    # 自己フォローは 403 を返す（テストの期待に一致）
    if current_user.id == @user.id
      respond_to do |format|
        format.html { head :forbidden }
        format.turbo_stream { head :forbidden }
      end
      return
    end

    # 重複フォローは作らない（冪等）
    current_user.active_relationships.find_or_create_by!(followed: @user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: @user, notice: 'フォローしました' }
    end
  rescue ActiveRecord::RecordNotFound
    # 万一パラメータ不正なら 404
    respond_to do |format|
      format.html { head :not_found }
      format.turbo_stream { head :not_found }
    end
  end

  def destroy
    # 自分が follower の関係だけ削除可能（安全）
    @relationship = current_user.active_relationships.find(params[:id])
    @user = @relationship.followed # ← 「following」ではなく「followed」に修正

    @relationship.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: @user, notice: 'フォロー解除しました' }
    end
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Relationship not found.'
    redirect_to root_path
  end
end
