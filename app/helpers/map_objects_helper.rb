module MapObjectsHelper
  def get_safe_id(map_object)
    map_object.try(:id)
  end

  def yesno(value)
    value ? 'yes' : 'no'
  end
  
  def format_color(o)
    if o.cleared
      '#linestyle_blue'
    elsif o.claimed
      '#linestyle_yellow'
    elsif o.need_help
      '#linestyle_red'
    else
      '#linestyle_white'
    end
  end
end
