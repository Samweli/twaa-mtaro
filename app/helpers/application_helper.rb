module ApplicationHelper
  def yesno(value)
    value ? t("notices.true_value") : t("notices.false_value")
  end

end
