class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :first_name, :last_name, :organization, :sms_number, :password, :password_confirmation, :remember_me
  validates_presence_of :first_name, :last_name
  has_many :sidewalk_claims

  def short_name
    "#{first_name} #{last_name.chr}."
  end

  def fullname
    first_name + ' ' + last_name
  end

end
