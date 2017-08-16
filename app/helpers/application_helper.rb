module ApplicationHelper
  def yesno(value)
    value ? t("notices.true_value") : t("notices.false_value")
  end

  def noyes(value)
    value ? t("notices.false_value") : t("notices.true_value")
  end

end

