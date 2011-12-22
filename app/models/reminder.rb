class Reminder < ActiveRecord::Base
  validates_presence_of :from_user, :to_user, :map_object
  belongs_to :from_user, :class_name => "User"
  belongs_to :to_user, :class_name => "User"
  belongs_to :map_object
end
