class LikesController < ApplicationController
  before_action :set_post

  def create
    if @post.liked_users.include?(current_user)
      respond_to do |format|
        format.html { redirect_to posts_path, notice: 'すでにいいねしています。' }
        format.js { render js: "alert('すでにいいねしています。');" }
      end
      return
    end

    # 新しいいいねの作成
    if @post.likes.create(user: current_user)
      respond_to do |format|
        format.html { redirect_to posts_path, notice: 'いいねしました！' }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_path, alert: 'いいねに失敗しました。' }
        format.js { render js: "alert('いいねに失敗しました。');" }
      end
    end
  end

  def destroy
    @like = Like.find_by(post_id: @post.id, user_id: current_user.id)

    if @like
      @like.destroy
      respond_to do |format|
        format.js
      end
    else
      # エラーの代わりに何もしないか、メッセージを表示するなど
      respond_to do |format|
        format.js { render inline: "console.error('Like not found');" }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
