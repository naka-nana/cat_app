require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe 'POST /posts/:post_id/comments' do
    context 'ログインしているとき' do
      it 'コメントできる' do
        user     = FactoryBot.create(:user)
        post_rec = FactoryBot.create(:post) # 別ユーザーの投稿
        sign_in_as(user)

        expect do
          post post_comments_path(post_rec), params: {
            comment: { content: 'かわいい' }
          }
        end.to change(Comment, :count).by(1)

        expect(response).to have_http_status(:redirect)
      end

      it '内容が空だと増えない（422 or 302想定）' do
        user     = FactoryBot.create(:user)
        post_rec = FactoryBot.create(:post)
        sign_in_as(user)

        expect do
          post post_comments_path(post_rec), params: {
            comment: { content: '' }
          }
        end.not_to change(Comment, :count)

        expect(response.status).to(satisfy { |s| [422, 302].include?(s) })
      end
    end

    context 'ログインしていないとき' do
      it '401（またはログインへリダイレクト）' do
        post_rec = FactoryBot.create(:post)
        post post_comments_path(post_rec), params: { comment: { content: 'にゃ' } }

        expect(response).to have_http_status(:unauthorized)
          .or have_http_status(:redirect)
      end
    end
  end

  describe 'DELETE /posts/:post_id/comments/:id' do
    context 'ログインしているとき' do
      it '本人は削除できる' do
        comment = FactoryBot.create(:comment) # user と post が紐づく想定
        sign_in_as(comment.user)

        expect do
          delete post_comment_path(comment.post, comment)
        end.to change(Comment, :count).by(-1)

        expect(response).to have_http_status(:redirect)
      end

      it '他人のコメントは削除できない（403 or リダイレクト）' do
        comment = FactoryBot.create(:comment)
        other   = FactoryBot.create(:user)
        sign_in_as(other)

        expect do
          delete post_comment_path(comment.post, comment)
        end.not_to change(Comment, :count)

        expect(response).to have_http_status(:forbidden)
          .or have_http_status(:redirect)
      end
    end

    context 'ログインしていないとき' do
      it '401（またはログインへリダイレクト）' do
        comment = FactoryBot.create(:comment)

        delete post_comment_path(comment.post, comment)

        expect(response).to have_http_status(:unauthorized)
          .or have_http_status(:redirect)
      end
    end
  end
end
