class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :first_name, :last_name, :organization, :sms_number, :password, :password_confirmation, :remember_me
  validates_presence_of :first_name, :last_name
  has_many :reminders_to, :class_name => "Reminder", :foreign_key => "to_user_id"
  has_many :reminders_from, :class_name => "Reminder", :foreign_key => "from_user_id"
  has_many :map_objects

  def fullname
    first_name + ' ' + last_name
  end

end
