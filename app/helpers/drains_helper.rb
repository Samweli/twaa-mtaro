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
       end
    else
      "#unknown"
    end
  end

  def count(drains, value)
  
  end

end
