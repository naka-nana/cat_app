require 'rails_helper'

RSpec.describe Like, type: :model do
  before do
    @like = FactoryBot.build(:like)
  end

  describe 'いいね機能' do
    it '同じユーザーが同じ投稿に2回いいねできない' do
      @like.save
      another_like = FactoryBot.build(:like, user: @like.user, post: @like.post)
      another_like.valid?
      expect(another_like.errors.full_messages).to include('User Post has already been taken')
    end
  end
end
