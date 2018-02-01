module NeedHelpsHelper
  # checks if current user is the one
  # who created the need help request
  def my_need_help_request(need_help)
    if iam_street_leader(need_help.drain)
      need_help.user == current_user
    else
      false
    end
  end
end
