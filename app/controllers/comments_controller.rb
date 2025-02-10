class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: 'コメントが追加されました。' }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('comment_form', partial: 'comments/form',
                                                                    locals: { post: @post, comment: @comment })
        end
        format.html { render 'posts/show', alert: 'コメントの追加に失敗しました。' }
      end
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: 'コメントを削除しました。' }
      end
    else
      respond_to do |format|
        format.html { redirect_to @post, alert: '他のユーザーのコメントは削除できません。' }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def authenticate_user!
    return if user_signed_in?

    redirect_to new_user_session_path, alert: 'コメントをするにはログインが必要です。'
  end
end
