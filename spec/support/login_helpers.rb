module LoginHelpers
  def sign_in_as(user)
    # Basic認証をバイパス（ApplicationControllerで before_action :basic_auth の想定）
    begin
      allow_any_instance_of(ApplicationController)
        .to receive(:basic_auth).and_return(true)
    rescue NameError
      # メソッド名が違う場合の保険（authenticate_or_request_with_http_basicを直接呼んでいるなど）
      allow(ActionController::HttpAuthentication::Basic)
        .to receive(:authenticate).and_return([true, nil])
      allow(ActionController::HttpAuthentication::Basic)
        .to receive(:authenticate_with_http_basic).and_return([true, nil])
    end

    # Deviseがあれば本物で、なければモックでログイン
    if defined?(sign_in)
      sign_in user
    else
      allow_any_instance_of(ApplicationController)
        .to receive(:authenticate_user!).and_return(true)
      allow_any_instance_of(ApplicationController)
        .to receive(:current_user).and_return(user)
    end
  end
end

RSpec.configure do |config|
  config.include LoginHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :request if defined?(Devise)
end
