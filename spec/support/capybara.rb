require 'capybara/rspec'
require 'capybara/cuprite'

Capybara.register_driver :cuprite do |app|
  Capybara::Cuprite::Driver.new(
    app,
    browser_path: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome', # ← このパスを指定
    headless: true,
    process_timeout: 60,
    timeout: 60,
    window_size: [1280, 800],
    browser_options: {
      "no-sandbox": nil,
      "disable-gpu": nil,
      "disable-dev-shm-usage": nil
    }
  )
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :cuprite
  end
end
