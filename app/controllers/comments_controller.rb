class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :set_post
  before_action :set_comment, only: [:edit, :update, :destroy]

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
        format.html { render 'posts/show', status: :unprocessable_entity, alert: 'コメントの追加に失敗しました。' }
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

  def edit
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.html # 通常のリクエストに対応
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("comment_#{@comment.id}", partial: 'comments/form',
                                                                            locals: { comment: @comment })
      end
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to post_path(@post), notice: 'コメントが更新されました。'
    else
      render :edit, status: :unprocessable_entity
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
