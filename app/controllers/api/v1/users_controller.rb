class Api::V1::UsersController < Api::V1::BaseController
  before_filter :authenticate_user!, only: [:show]

  def index
    users = User.all

    render(
        json: ActiveModel::ArraySerializer.new(
            users,
            each_serializer: Api::V1::UserSerializer,
            root: 'users',
        )
    )
  end

  def show
    user = User.find(params[:id])

    render(json: Api::V1::UserSerializer.new(user).to_json)
  end

  def remind
    user = User.joins(:roles).where(roles: { id: 2 })
               .find_by_street_id(params[:street_id])
    user.each do |u|
      sms_service = SmsService.new();
      msg = params[:message]
      sms_service.send_sms(
          msg,
          u.sms_number);

    end

    render :status => 200,
           :json => {:success => true,
                     :info => "Reminder sent"}

  end

  def verify_leader
    User.assign_role(params[:user_id], params[:role_id])
    render :json => { :success => true}
  end

  def requested_roles
    user_requests = User.role_requests(params[:role_name])
    render :json => {:leaders => user_requests}
  end

  def update
    user = User.find(params[:id])

    if !user.update_attributes(first_name: params[:first_name],
                               sms_number: params[:sms_number],
                               last_name: params[:last_name],
                               password: params[:password], email: params[:email],
                               street_id: params[:street_id])
      return api_error(status: 422, errors: user.errors)
    end

    render(
        json: Api::V1::UserSerializer.new(user).to_json,
        status: 200,
        location: api_v1_user_path(user.id)
    )
  end

  def destroy
    user = User.find(params[:id])

    if !user.destroy
      return api_error(status: 500)
    end

    head status: 204
  end


  private

  def create_params
    params.require(:user)
  end

  def update_params
    create_params
  end

  def text_message(type)
    if type == 'remind'
      if I18n.locale == :en
        msg = " Your Ward Executive officer reminds you to make more efforts on supervising"\
              "Drain Clealiness on Your Street "\
              "Failure to compliy with this requirement Administratize Adminstrative procedures will follow."
      else
        msg = "Mtendaji Wa kata Yako Anakuhimiza kuongeza juhudi katika kusimamia usafi wa mitaro mtaani kwako, "\
               "Kushindwa kuongeza juhudi katika usafi kutasababisha taratibu za kiutawala kufuatwa"\
               "Tafadhali ongeza juhudi ili kujiepusha na hatua zitakazo chukuliwa."
      end
    end

    return msg
  end

end