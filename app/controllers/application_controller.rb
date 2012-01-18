class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :authenticate_user!
  before_filter :set_flash_from_params
  before_filter :set_locale

  require 'rest-client'

  def publish_facebook_status(message)
    begin
      if (token = session.fetch('fb_access_token', nil))
        RestClient.post 'https://graph.facebook.com/me/feed',
                        :message => message, :access_token => token
      end
    rescue RestClient::Exception => e
      case e.response.code
        when 400
          #client = OAuth2::Client.new('', '', :site => 'https://graph.facebook.com')
          #token = OAuth2::AccessToken.new(client, token)          
      end
    end
  end


protected

  def set_flash_from_params
    if params[:flash]
      params[:flash].each do |key, message|
        flash.now[key.to_sym] = message
      end
    end
  end

  def set_locale
    I18n.locale = env['rack.locale'] || I18n.default_locale
  end
end
