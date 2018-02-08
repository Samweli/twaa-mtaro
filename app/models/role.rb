class Role < ActiveRecord::Base
  has_many :assignments
  has_many :users, through: :assignments
  validates :name, presence: true, uniqueness: true
  attr_accessible :name

  def self.not_my_roles(user)
    all_roles = Role.select("id")
    user_roles = user.roles.select("roles.id")

    all_combined_roles = all_roles + user_roles
    distint = all_combined_roles - (all_roles & user_roles)

    final_roles = Role.find_all_by_id(distint)
  end
end
