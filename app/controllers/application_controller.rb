class ApplicationController < ActionController::Base
  protect_from_forgery

  USER_NAME, PASSWORD = "palma", "isthatso"

  before_filter :authenticate
  def authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == USER_NAME && password == PASSWORD
    end
  end

end
