class ApplicationController < ActionController::Base
  before_action :basic_auth, if: -> { Rails.env.production? && ENV['BASIC_AUTH_USER'].present? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |u, p|
      ActiveSupport::SecurityUtils.secure_compare(u, ENV['BASIC_AUTH_USER']) &
        ActiveSupport::SecurityUtils.secure_compare(p, ENV['BASIC_AUTH_PASSWORD'])
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end
end
