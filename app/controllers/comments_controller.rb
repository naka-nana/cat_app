class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.js # 非同期でcreate.js.erbを呼び出す
      end
    else
      respond_to do |format|
        format.js { render js: "alert('コメントの保存に失敗しました。');" }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
