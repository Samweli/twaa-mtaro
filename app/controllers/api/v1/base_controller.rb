class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_filter :destroy_session

  def destroy_session
    request.session_options[:skip] = true
  end

  def not_found
    return api_error(status: 404, errors: 'Not found')
  end

  def api_error(status: 500, errors: [])
    unless Rails.env.production?
      puts errors.full_messages if errors.respond_to? :full_messages
    end
    head status: status and return if errors.empty?

    render json: errors.to_json, status: status
  end

  def authenticate_user!
    token, options = ActionController::HttpAuthentication::Token.token_and_options(request)

    user_email = options.blank?? nil : options[:email]
    user = user_email && User.find_by_email(user_email)

    if user && ActiveSupport::SecurityUtils.secure_compare(user.authentication_token, token)
      @current_user = user
    else
      return unauthenticated!
    end
  end

  def unauthenticated!
    response.headers['WWW-Authenticate'] = "Token realm=Application"
    render json: {error: 'Bad credentials'}, status: 401
  end
end