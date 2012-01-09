module SidewalksHelper
  def format_color(s)
    if s.cleared
      '#linestyle_blue'
    elsif s.num_adopted > 0
      '#linestyle_yellow'
    elsif s.need_help
      '#linestyle_red'
    else
      '#linestyle_white'
    end
  end
end
