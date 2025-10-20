require 'capybara/cuprite'

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    # ここが超重要：デフォルト10秒 → 60秒に延長
    process_timeout: 60,
    timeout: 60,
    window_size: [1400, 1400],
    # Mac での相性ケア
    browser_options: {
      "no-sandbox": nil,
      "disable-gpu": nil
    },
    # 必要なら Chrome の絶対パスを指定（起動に苦戦する環境向け）
    # browser_path: "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    headless: true
  )
end

Capybara.javascript_driver = :cuprite

RSpec.configure do |config|
  # 非JSテストは最速の rack_test
  config.before(:each, type: :system, js: false) do
    driven_by :rack_test
  end

  # JSテストは cuprite を確実に使う
  config.before(:each, type: :system, js: true) do
    driven_by :cuprite
  end
end
