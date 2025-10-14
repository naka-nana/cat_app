class LikesController < ApplicationController
  before_action :set_post

  def create
    return if already_liked?

    @post.likes.create(user: current_user)
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
        render turbo_stream: turbo_stream.replace("like_button_#{@post.id}", partial: 'posts/like_button',
                                                                             locals: { post: @post })
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
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
