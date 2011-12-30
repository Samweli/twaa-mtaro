module MapObjectsHelper
  def get_safe_id(map_object)
    map_object.try(:id)
  end

  def yesno(value)
    value ? 'yes' : 'no'
  end
  
  def format_color(s)
    #K: temp hack, 1-n issue make it efficient
    if o = MapObject.find_by_gid(s.gid)
      if o.cleared
        '#linestyle_blue'
      elsif o.claimed
        '#linestyle_yellow'
      elsif o.need_help
        '#linestyle_red'
      else
        '#linestyle_white'
      end
    else
      '#linestyle_white'
    end
  end
end
