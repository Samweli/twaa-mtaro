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

  def create
    user = User.create(first_name: params[:first_name],
                       sms_number: params[:sms_number],
                       last_name: params[:last_name],
                       password: params[:password],email: params[:email],
                       street_id: params[:street_id])
    return api_error(status: 422, errors: user.errors) unless user.valid?

    user.save!

    render(
        json: Api::V1::UserSerializer.new(user).to_json,
        status: 201,
        location: api_v1_user_path(user.id)
    )
  end

  def update
    user = User.find(params[:id])

    if !user.update_attributes(first_name: params[:first_name],
                               sms_number: params[:sms_number],
                               last_name: params[:last_name],
                               password: params[:password],email: params[:email],
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

end