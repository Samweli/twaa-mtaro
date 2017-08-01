class UsersController < Devise::RegistrationsController
  layout 'info_window'

  def new
    respond_with (@user = User.new)
  end

  def index
    @users = User.all
    respond_to do |format|
      format.json { render json: @users }
    end
  end

  def edit
    render :edit
  end
  def add
    render :add
  end

  def update
    if resource.update_with_password(params[resource_name])
      sign_in(resource_name, resource, :bypass => true)
      flash[:notice] = "Profile updated!"
      redirect_to(:controller => "info_window", :action => "index", :map_object_id => params[:map_object_id])
    else
      clean_up_passwords(resource)
      render(:json => {"errors" => resource.errors}, :status => 500)
    end
  end

  def create
    build_resource
    if resource.save
      sign_in resource
      session[:omniauth] = nil unless @user.new_record?
      render(:json => {"message" => "you have signed up successfully"}, :status => 200) and return
    else
      errors = resource.errors
    end

    #set_flash_message :notice, :inactive_signed_up, :reason => errors if is_navigational_format?
    flash.now[:error] = errors
    flash.delete(:recaptcha_error)

    clean_up_passwords(resource)
    render(:json => {"errors" => errors,
                     :html => render_to_string(:template => 'users/new.html.haml')},
           :status => 500)
  end

  def createuser
    build_resource
    if resource.save
      session[:omniauth] = nil unless @user.new_record?
      sms_service = SmsService.new();
      if I18n.locale == :en
        msg = "Your Twaa mtaro account has been created, go to http://twaamtaro.org "\
              "and login with "\
              "your number and password #{@user.password}"
      else
         msg = "Umesajiliwa kwenye tovuti ya Twaa mtaro imetengenezwa,"\
               "ingia http://twaamtaro.org"\
               "kwa kutumia namba yako ya simu na nywila #{@user.password}"
      end
      sms_service.send_sms(
        msg, 
        @user.sms_number);

      render(:json => {"user" => resource}, :status => 200) and return
    else
      errors = resource.errors
    end

    #set_flash_message :notice, :inactive_signed_up, :reason => errors if is_navigational_format?
    flash.now[:error] = errors
    flash.delete(:recaptcha_error)

    clean_up_passwords(resource)
    render(:json => {"errors" => errors,
                     :html => render_to_string(:template => 'users/add.html.haml')},
           :status => 500)
  end


  private

  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end

end
