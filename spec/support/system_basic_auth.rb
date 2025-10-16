module SystemBasicAuth
  def visit_with_basic_auth(path)
    user = ENV.fetch('BASIC_AUTH_USER', 'user')
    pass = ENV.fetch('BASIC_AUTH_PASSWORD', 'password')
    host = Capybara.current_session.server.host
    port = Capybara.current_session.server.port
    visit "http://#{user}:#{pass}@#{host}:#{port}#{path}"
  end
end

RSpec.configure do |config|
  config.include SystemBasicAuth, type: :system
end
