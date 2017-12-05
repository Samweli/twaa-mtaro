class User < ActiveRecord::Base
  before_save :ensure_authentication_token
  devise :database_authenticatable, :token_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => {sms_number: true}
  attr_accessible :email, :admin, :role_requested, :first_name, :last_name, :organization, :sms_number, :password, :password_confirmation, :street_id, :remember_me
  validates_presence_of :first_name, :last_name, :street_id, :sms_number
  has_many :drain_claims
  has_many :assignments
  has_many :authentications
  has_many :roles, through: :assignments
  has_many :need_helps, :class_name => 'NeedHelp', :foreign_key => "user_id"
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

  def role?(role)
    roles.any? {|r| r.name.underscore.to_sym == role}
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

  def self.assign_role(user_id, role_id)
    user_role = Assignment.new(:role_id => role_id, :user_id => user_id)
    user_role.save
    request_account(user_id, nil)
  end

  def has_role(role_id)
    self.roles.include? Role.find(role_id)
  end

  def self.request_account(user_id, role_id)
    user = User.find(user_id)
    user.update_attribute(:role_requested, role_id)
  end

  def self.role_requests(requested_role)
    requested_role = Role.find_by_name(requested_role)
    if requested_role
      User.find_by_role_requested(requested_role.id)
    else
      User.where("role_requested IS NOT NULL")
    end
  end

  def generate_authentication_token
    loop do
      self.authentication_token = SecureRandom.urlsafe_base64
      break unless User.find_by_authentication_token(authentication_token)
    end
  end

end
