module ApplicationHelper
  def yesno(value)
    value ? t("notices.yes_value") : t("notices.no_value")
  end

  def noyes(value)
    value ? t("notices.no_value") : t("notices.yes_value")
  end

end

