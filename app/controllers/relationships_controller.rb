class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create

    @user = User.find(follow_target_id) # フォローされる側


    # 自己フォロー禁止は「作る前」に弾く
    if current_user.id == @user.id
      respond_to do |f|
        f.turbo_stream { head :forbidden }
        f.html         { head :forbidden }
      end
      return
    end

    # 冪等に作成（既にあれば何もしない）
    current_user.active_relationships.find_or_create_by!(followed: @user)

    # 描画前に関連キャッシュを確実にクリア
    current_user.reload
    @user.reload

    respond_to do |f|
      f.turbo_stream
      f.html { redirect_to @user, notice: 'フォローしました' }
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |f|
      f.turbo_stream { head :not_found }
      f.html         { head :not_found }
    end
  end

  def destroy
    rel   = current_user.active_relationships.find(params[:id]) # 自分がfollowerの関係だけ触れる
    @user = rel.followed                                        # 相手
    rel.destroy!

    current_user.reload
    @user.reload

    respond_to do |f|
      f.turbo_stream
      f.html { redirect_to @user, notice: 'フォロー解除しました' }
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |f|
      f.turbo_stream { head :not_found }
      f.html do
        flash[:alert] = 'Relationship not found.'
        redirect_to root_path
      end
    end
  end

  private

  # 画面/テストのどちらの形でも拾えるように一箇所で面倒を見る
  def follow_target_id
    params.dig(:relationship, :followed_id) ||
      params[:following_id] ||
      params[:followed_id]
  end
end
