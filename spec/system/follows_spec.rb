require 'rails_helper'

RSpec.describe 'フォロー機能', type: :system, js: true do
  let!(:me)   { create(:user) }
  let!(:them) { create(:user) }

  before { login_as(me, scope: :user) }

  it '他ユーザー詳細で『フォローする』→『フォロー解除』に切り替わる' do
    visit user_path(them)

    frame = "turbo-frame#follow-button-#{them.id}"
    expect(page).to have_css(frame, wait: 30)

    # 初期
    within frame do
      expect(page).to have_button('フォローする')
      click_button 'フォローする'
    end

    # ← within を抜けて、新しいDOMを待つ
    expect(page).to have_css("#{frame} button", text: 'フォロー解除', wait: 10)

    # 解除
    within frame do
      click_button 'フォロー解除'
    end
    expect(page).to have_css("#{frame} button", text: 'フォローする', wait: 10)
  end

  it '自分のプロフィールではフォローボタンが表示されない' do
    visit user_path(me)

    # フレームは存在（中身のボタンが無い）
    expect(page).to have_css("turbo-frame#follow-button-#{me.id}", wait: 10)
    within "turbo-frame#follow-button-#{me.id}" do
      expect(page).not_to have_button('フォローする')
      expect(page).not_to have_button('フォロー解除')
    end
  end
end
