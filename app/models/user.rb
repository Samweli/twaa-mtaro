class User < ActiveRecord::Base
  before_save :ensure_authentication_token
  devise :database_authenticatable,:token_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => {sms_number:true}
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

  def profile_name
    "#{first_name.chr}#{last_name.chr}"
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


  def generate_authentication_token
    loop do
      self.authentication_token = SecureRandom.urlsafe_base64
      break unless User.find_by_authentication_token(authentication_token)
    end
  end

end
