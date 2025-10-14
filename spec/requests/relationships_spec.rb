require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  describe 'POST /relationships' do
    context 'ログインしているとき' do
      it '他ユーザーをフォローできる' do
        me    = FactoryBot.create(:user)
        other = FactoryBot.create(:user)
        sign_in_as(me)

        expect do
          post relationships_path, params: { relationship: { followed_id: other.id } }
        end.to change(Relationship, :count).by(1)

        expect(response).to have_http_status(:redirect)
      end

      it '同じユーザーを重複フォローしても増えない' do
        me    = FactoryBot.create(:user)
        other = FactoryBot.create(:user)
        sign_in_as(me)

        post relationships_path, params: { relationship: { followed_id: other.id } }
        expect do
          post relationships_path, params: { relationship: { followed_id: other.id } }
        end.not_to change(Relationship, :count)
      end

      it '自分自身はフォローできない（禁止/リダイレクト想定）' do
        me = FactoryBot.create(:user)
        sign_in_as(me)

        expect do
          post relationships_path, params: { relationship: { followed_id: me.id } }
        end.not_to change(Relationship, :count)

        expect(response).to have_http_status(:forbidden).or have_http_status(:redirect)
      end
    end

    context 'ログインしていないとき' do
      it '401（またはログインへリダイレクト）' do
        other = FactoryBot.create(:user)

        post relationships_path, params: { relationship: { followed_id: other.id } }

        expect(response).to have_http_status(:unauthorized).or have_http_status(:redirect)
      end
    end
  end

  describe 'DELETE /relationships/:id' do
    context 'ログインしているとき' do
      it '自分のフォローは解除できる' do
        rel = FactoryBot.create(:relationship) # follower と followed を含む
        sign_in_as(rel.follower)

        expect do
          delete relationship_path(rel)
        end.to change(Relationship, :count).by(-1)

        expect(response).to have_http_status(:redirect)
      end

      it '他人のフォローは解除できない（禁止/リダイレクト想定）' do
        rel   = FactoryBot.create(:relationship)
        other = FactoryBot.create(:user)
        sign_in_as(other)

        expect do
          delete relationship_path(rel)
        end.not_to change(Relationship, :count)

        expect(response).to have_http_status(:forbidden).or have_http_status(:redirect)
      end
    end

    context 'ログインしていないとき' do
      it '401（またはログインへリダイレクト）' do
        rel = FactoryBot.create(:relationship)

        delete relationship_path(rel)

        expect(response).to have_http_status(:unauthorized).or have_http_status(:redirect)
      end
    end
  end
end
