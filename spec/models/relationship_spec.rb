require 'rails_helper'

RSpec.describe Relationship, type: :model do
  before do
    @follower = FactoryBot.create(:user)
    @followed = FactoryBot.create(:user)
    @relationship = FactoryBot.build(:relationship, follower: @follower, followed: @followed)
  end

  describe 'フォロー機能' do
    it 'ユーザーはフォローできる' do
      expect(@relationship).to be_valid
    end

    it '同じユーザーを2回フォローできない' do
      @relationship.save
      duplicate_follow = FactoryBot.build(:relationship, follower: @relationship.follower, followed: @relationship.followed)
      duplicate_follow.valid?
      expect(duplicate_follow.errors.full_messages).to include('Followed has already been taken')
    end
  end
end
