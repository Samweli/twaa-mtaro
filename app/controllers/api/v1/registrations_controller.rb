class Api::V1::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def create
    build_resource
    if resource.save
      User.assign_role(resource.id, 1)
      sign_in resource
      render(json: Api::V1::SessionSerializer.new(current_user, root: 'users').to_json)
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => resource.errors,
                        :data => {} }
    end
  end
end