module UsersHelper
  def is_leader(user)
    user.roles.include? Role.find(2)
  end
end
