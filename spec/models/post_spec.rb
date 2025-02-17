require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    @post = FactoryBot.build(:post) # テストデータ作成
  end

  describe '投稿の新規作成' do
    context '新規作成できるとき（正常系）' do
      it 'タイトル・コンテンツ・画像・ユーザーが全て正しく入力されていれば登録できる' do
        expect(@post).to be_valid
      end

      it 'タイトルが30文字以内なら登録できる' do
        @post.title = 'a' * 30
        expect(@post).to be_valid
      end

      it 'コンテンツが1000文字以内なら登録できる' do
        @post.content = 'a' * 1000
        expect(@post).to be_valid
      end
    end

    context '新規作成できないとき（異常系）' do
      it 'タイトルが空だと登録できない' do
        @post.title = ''
        @post.valid?
        expect(@post.errors.full_messages).to include("Title can't be blank")
      end

      it 'タイトルが31文字以上だと登録できない' do
        @post.title = 'a' * 31
        @post.valid?
        expect(@post.errors.full_messages).to include('Title is too long (maximum is 30 characters)')
      end

      it 'コンテンツが1001文字以上だと登録できない' do
        @post.content = 'a' * 1001
        @post.valid?
        expect(@post.errors.full_messages).to include('Content is too long (maximum is 1000 characters)')
      end

      it '画像がないと登録できない' do
        @post.image.purge # 画像を削除
        @post.valid?
        expect(@post.errors.full_messages).to include("Image can't be blank")
      end

      it 'ユーザーが存在しないと登録できない' do
        @post.user = nil
        @post.valid?
        expect(@post.errors.full_messages).to include('User must exist')
      end
    end
  end
end
