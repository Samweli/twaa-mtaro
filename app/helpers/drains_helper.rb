module DrainsHelper
  def format_color(s)
    if not s.cleared.nil?
      if s.cleared
        "#cleared"
      else
        "#unclear"
      end
      # elsif s.claims_count > 0
      #   "#adopted"
    elsif not s.need_help.nil?
      if s.need_help == true
        "#needs_help"
      else
        "#unknown"
      end
    else
      "#unknown"
    end
  end

  def count(drains, value)

  end

  def added(street_id, gid)
    drain = Drain.find_by_gid_and_street_id(gid, street_id)
    if drain
      return true
    end
    return false
  end

  def updates_authentication(user, drain)
    if user.present? && drain.present?
      if user.has_role(2)
        if drain.has_street(user.try(:street_id))
          return true
        end
      end
    end
    return false
  end

end
