require 'capybara/rspec'
require 'capybara/cuprite'

Capybara.register_driver :cuprite do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1400, 1400]
    # browser: :chrome  # ← デフォで通常の Chrome を使います（driver 不要）
  )
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :cuprite
  end
end
