class SessionsController < Devise::SessionsController
  def new
    render("new", :layout => "info_window")
  end

  def create
    if (resource = warden.authenticate(:scope => resource_name))
      sign_in(resource_name, resource)
      puts "resource: #{resource}"
    end
    
    respond_with(resource) do |format|
      format.html { redirect_to '/' }
      format.json { render :json => resource ? resource :
                      {"errors" => {:password => [t("errors.password")]}}, :status => 401 }
    end
  end

  def destroy
    signed_in = signed_in?(resource_name)
    sign_out(resource_name) if signed_in
    render(:json => {"success" => signed_in})
  end
end
