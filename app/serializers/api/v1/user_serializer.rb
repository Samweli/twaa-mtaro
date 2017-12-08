class Api::V1::UserSerializer < Api::V1::BaseSerializer
  attributes :id, :email, :first_name, :last_name, :organization, :sms_number

  has_many :roles, through: :assignments, embed: :objects
  has_one :street, embed: :objects


  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end
