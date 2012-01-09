module SidewalksHelper
  def format_color(s)
    if s.cleared
      "#cleared"
    elsif s.claims_count > 0
      "#adopted"
    elsif s.need_help
      "#needs_help"
    else
      "#unclear"
    end
  end
end
