module ApplicationHelper
  def yesno(value)
    value ? t("notices.yes_value") : t("notices.no_value")
  end

  def noyes(value)
    value ? t("notices.no_value") : t("notices.yes_value")
  end

  # checks if street of current user
  # is the same as drains street
  def my_street(drain)
    if user_signed_in?
      return true if drain.streets.include? current_user.street
    else
      false
    end
  end

  # checks if current user is the street leader
  # of the drain's street
  def iam_street_leader(drain)
    if my_street(drain)
      current_user.has_role(2)
    else
      false
    end
  end

end

