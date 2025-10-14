require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  describe 'POST /posts/:post_id/like' do
    context 'ログインしているとき' do
      it '他人の投稿にいいねできる' do
        user = FactoryBot.create(:user)
        post_rec = FactoryBot.create(:post) # 投稿者は別のユーザー
        sign_in_as(user)

        expect do
          post post_like_path(post_rec)
        end.to change(Like, :count).by(1)

        expect(response).to have_http_status(:redirect)
      end

      it '同じ投稿に二重いいねできない' do
        user = FactoryBot.create(:user)
        post_rec = FactoryBot.create(:post)
        sign_in_as(user)

        post post_like_path(post_rec)
        expect do
          post post_like_path(post_rec)
        end.not_to change(Like, :count)
      end

      it '自分の投稿にはいいねできない（仕様に応じて）' do
        post_rec = FactoryBot.create(:post)
        sign_in_as(post_rec.user)

        expect do
          post post_like_path(post_rec)
        end.not_to change(Like, :count)

        expect(response).to have_http_status(:forbidden).or have_http_status(:redirect)
      end
    end

    context 'ログインしていないとき' do
      it '401を返す' do
        post_rec = FactoryBot.create(:post)
        post post_like_path(post_rec)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /posts/:post_id/like' do
    context 'ログインしているとき' do
      it 'いいね解除できる' do
        like = FactoryBot.create(:like) # Factoryで user と post も関連づけて作成
        sign_in_as(like.user)

        expect do
          delete post_like_path(like.post)
        end.to change(Like, :count).by(-1)

        expect(response).to have_http_status(:redirect)
      end
    end

    context 'ログインしていないとき' do
      it '401を返す' do
        like = FactoryBot.create(:like)
        delete post_like_path(like.post)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
