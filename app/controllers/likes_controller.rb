class LikesController < ApplicationController
  # 任意：未ログインを弾く（posts と同じ挙動にそろえるなら推奨）
  before_action :authenticate_user!

  before_action :set_post

  def create
    # ① 自分の投稿なら 403（テストの期待に一致）
    return forbid_own_post if @post.user_id == current_user.id

    # ② 既にいいね済みなら既存処理
    return if already_liked?

    @post.likes.create!(user: current_user)

    respond_to do |format|
      format.html { redirect_to request.referer || posts_path }
      format.js
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("like_button_#{@post.id}", partial: 'posts/like_button', locals: { post: @post }),
          turbo_stream.replace("like_count_#{@post.id}", partial: 'posts/like_count', locals: { post: @post })
        ]
      end
    end
  end

  def destroy
    like = @post.likes.find_by(user_id: current_user.id)
    like&.destroy

    respond_to do |format|
      format.html { redirect_to request.referer || posts_path }
      format.js
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("like_button_#{@post.id}", partial: 'posts/like_button', locals: { post: @post }),
          turbo_stream.replace("like_count_#{@post.id}", partial: 'posts/like_count', locals: { post: @post })
        ]
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  # ③ 自分の投稿をいいねしようとした時の共通レスポンス
  def forbid_own_post
    respond_to do |format|
      # テストは :forbidden or redirect の両方許容だが、ここでは明示的に 403 を返す
      format.html { head :forbidden }
      format.js { head :forbidden }
      format.turbo_stream { head :forbidden }
    end
  end

  def already_liked?
    if @post.likes.exists?(user_id: current_user.id)
      respond_to do |format|
        format.html { redirect_to request.referer || posts_path, notice: 'すでにいいねしています。' }
        format.js { render js: "alert('すでにいいねしています。');" }
        format.turbo_stream
      end
      return true
    end
    false
  end
end
