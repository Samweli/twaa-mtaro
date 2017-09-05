class Api::V1::SessionSerializer < Api::V1::BaseSerializer
  #just some basic attributes
  attributes :email, :first_name, :last_name, :organization, :sms_number

  def token
    object.authentication_token
  end
end