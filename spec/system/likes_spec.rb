require 'rails_helper'

RSpec.describe 'いいね（Like）', type: :system, js: true do
  let!(:user)      { create(:user) }
  let!(:other)     { create(:user) }
  let!(:others_post) { create(:post, user: other) }
  let!(:own_post)    { create(:post, user: user) }

  before do
    Warden.test_mode!
    login_as(user, scope: :user) # ← System spec では sign_in ではなくこれ！
  end

  it '投稿詳細で「いいね」→「いいね解除」が画面に即反映される' do
    visit post_path(others_post)

    # 本当に詳細にいるかのガード（未ログインやルーティング不備だとここで落ちる）
    expect(page).to have_content(others_post.title)

    # 初期は 0 いいね
    expect(page).to have_selector('.like-section .like-count', text: /\A0\s*いいね\z/)

    # いいね → 1 いいね
    click_button 'いいね'
    expect(page).to have_selector('.like-section .like-count', text: /\A1\s*いいね\z/)

    # いいね解除 → 0 いいね
    click_button 'いいね解除'
    expect(page).to have_selector('.like-section .like-count', text: /\A0\s*いいね\z/)
  end

  it '自分の投稿にはいいねできない（禁止仕様）' do
    visit post_path(own_post)
    expect(page).to have_content(own_post.title)

    # 数字は0のまま
    expect(page).to have_selector('.like-section .like-count', text: /\A0\s*いいね\z/)
    # ボタン自体が表示されない前提にする
    expect(page).not_to have_button('いいね')
  end
end
