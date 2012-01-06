module MapObjectsHelper
  def get_safe_id(map_object)
    map_object.try(:id)
  end

  def yesno(value)
    value ? 'yes' : 'no'
  end
  
  def format_color(s)
    #K: temp hack, 1-n issue make it efficient
    line_style = '#linestyle_white'
    
    MapObject.where(:gid => s.gid).all.each do |o|
      if o.cleared
        return '#linestyle_blue'
      elsif o.claimed
        line_style = '#linestyle_yellow'
      elsif o.need_help
        line_style = '#linestyle_red'
      else
        line_style = '#linestyle_white'
      end
    end
    
    return line_style
  end
  
end
