class MainController < ApplicationController
  def index
    get_my_drains
    get_drains_categories
  end

  def sidebar
    get_my_drains
    drain_list = render_to_string :partial => 'drain_list', :formats => [:html] 
    address_box = render_to_string :partial => 'address_form', :formats => [:html]

    respond_to do |format|
      format.js   { render :locals => { :drain_list => drain_list } }
      format.json { 
        render :json => {:drain_list => drain_list, :address_box => address_box}
      }
    end
  end
  
  private
  
  def get_my_drains
    if user_signed_in?
      @my_drains = current_user.drain_claims.includes(:drain).page(params[:page]).per(2)
    end
  end

  def get_drains_categories
    @clean = format_number(Drain.count(:conditions => 'cleared = true') )
    @unclean = format_number(Drain.count(:conditions => 'cleared = false'))
    @need_help = format_number(Drain.count(:conditions => 'need_help = true'))
    @unknown = format_number(Drain.where('cleared is NULL and need_help is NULL').count)
    @all = format_number(Drain.count)
    @priorities = format_number(Priority.count)
    puts "priorites"
    puts @priorities

    @adopted = format_number(Drain.count(:conditions => 'claims_count > 0'))
    @not_adopted = format_number(Drain.count(:conditions => 'claims_count = 0'))

    Rails.logger.debug("adopted #{@adopted}, #{@not_adopted}")

  end

  def format_number(number)
    formatted_number = number.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
    return formatted_number
  end


end
