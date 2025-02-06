class LikesController < ApplicationController
  class LikesController < ApplicationController
    before_action :set_post

    def create
      @post.likes.create(user: current_user)
      respond_to do |format|
        format.html { redirect_to posts_path }
        format.js  # 非同期用
      end
    end

    def destroy
      @post.likes.find_by(user: current_user).destroy
      respond_to do |format|
        format.html { redirect_to posts_path }
        format.js  # 非同期用
      end
    end

    private

    def set_post
      @post = Post.find(params[:post_id])
    end
  end
end
