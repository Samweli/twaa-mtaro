class SessionsController < Devise::SessionsController
  def new
    render :new, :layout => "info_window"
  end

  def create
    if (resource = warden.authenticate(:scope => resource_name))
      sign_in(resource_name, resource)
      render :json => resource
    else
      render :json => {"errors" => {:password => [t("errors.auth_failed")]}}, :status => :unauthorized 
    end
  end

  def destroy
    signed_in = signed_in?(resource_name)
    sign_out(resource_name) if signed_in
    redirect_to '/'
  end
end
