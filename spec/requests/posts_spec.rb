require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:image_path) { Rails.root.join('spec/fixtures/test_image.jpg') }
  let(:file) { Rack::Test::UploadedFile.new(image_path, 'image/jpeg') }

  describe 'POST /posts' do
    context 'ログインしているとき' do
      it '投稿できる' do
        user = FactoryBot.create(:user)
        sign_in_as(user)

        expect do
          post posts_path, params: {
            post: {
              title: 'テスト投稿',
              content: 'にゃー',
              image: file,
              cat_ids: []
            }
          }
        end.to change(Post, :count).by(1)

        expect(response).to redirect_to(posts_path)
      end
    end

    context 'ログインしていないとき' do
      it '投稿できず、401を返す' do
        post posts_path, params: { post: { title: '未ログイン', content: 'にゃ' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
