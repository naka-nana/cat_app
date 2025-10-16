require 'rails_helper'

RSpec.describe '投稿機能', type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    driven_by(:rack_test)
    # UIを使わずログイン（Devise/Warden）
    login_as(user, scope: :user)

    # ★ Basic認証があるならここで通過（ENVがなければデフォルト値で試す）
    if page.driver.browser.respond_to?(:authorize)
      basic_user = ENV.fetch('BASIC_AUTH_USER', 'user')
      basic_pass = ENV.fetch('BASIC_AUTH_PASSWORD', 'password')
      page.driver.browser.authorize(basic_user, basic_pass)
    end
  end

  it 'ログインして新規投稿ができる' do
    visit new_post_path

    # ★ まずフォームの存在を確認してからスコープを決める
    form_scope =
      if page.has_css?('form#new_post')
        'form#new_post'
      elsif page.has_css?('form[action*="/posts"]')
        'form[action*="/posts"]'
      else
        # デバッグしやすいように失敗時に内容を出す
        raise "form not found. current_path=#{page.current_path}\n\n#{page.body[0..500]}"
      end

    within(form_scope) do
      # name属性で確実に入力
      find('input[name="post[title]"]').set('テスト投稿')

      if page.has_css?('textarea[name="post[content]"]')
        find('textarea[name="post[content]"]').set('にゃー')
      else
        find('input[name="post[content]"]').set('にゃー')
      end

      image_path = Rails.root.join('spec/fixtures/test_image.jpg')
      attach_file 'post[image]', image_path if File.exist?(image_path)

      first('input[type="submit"],button[type="submit"]').click
    end

    expect(page).to have_content('テスト投稿')
    expect(page).to have_content('にゃー')
  end
end
