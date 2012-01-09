module SidewalksHelper
  def format_color(s)
    if s.cleared
      "#cleared"
    elsif s.num_adopted > 0
      "#adopted"
    elsif s.need_help
      "#needs_help"
    else
      "#unclear"
    end
  end
end
