class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => {sms_number:true}
  attr_accessible :email, :first_name, :last_name, :organization, :sms_number, :password, :password_confirmation, :street_id, :remember_me
  validates_presence_of :first_name, :last_name, :street_id
  has_many :drain_claims
  has_many :authentications
  belongs_to :street

  def short_name
    "#{first_name} #{last_name.chr}."
  end

  def fullname
    first_name + ' ' + last_name
  end

  def apply_omniauth(omniauth)
    self.first_name = omniauth[:info][:first_name] if first_name.blank?
    self.last_name = omniauth[:info][:last_name] if last_name.blank?
    self.email = omniauth[:info][:email] if email.blank?
    authentications.build(:provider => omniauth[:provider],
                          :uid => omniauth[:uid],
                          #:token => omniauth[:credentials][:token]
                          )
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

end
