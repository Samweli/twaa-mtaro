class MapObject < ActiveRecord::Base
  belongs_to :user
  has_many :reminders

  def adopted?
    false
    #!user_id.nil?
  end
end
