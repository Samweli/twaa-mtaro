class AuthenticationsController < ApplicationController
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    status = :ok
    if authentication
      sign_in_and_redirect :user, authentication.user
      current_user.apply_omniauth(omniauth)
      current_user.save if current_user.changed?
      authentication.save!
      authenticated = true
      result = "Welcome back!"
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      current_user.apply_omniauth(omniauth)
      current_user.save!
      authenticated = true
      result = "User authenticated via #{omniauth['provider']}."
      redirect_to '/'
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        result = "New user has authenticated via #{omniauth['provider']}."
        authenticated = true
        sign_in user
      else
        session[:omniauth] = omniauth.except('extra')
        authenticated = false
        status = :internal_server_error
        result = "#{omniauth['provider']} authentication failed."
        redirect_to '/'
      end
    end
    
    #render :json => {:authenticated => authenticated, :result => result, :status => status}
  end
end
