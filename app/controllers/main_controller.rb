class MainController < ApplicationController
  def index
    get_my_drains
    get_drains_categories
  end

  def sidebar
    get_my_drains
    drain_list = render_to_string :partial => 'drain_list.html.haml'

    respond_to do |format|
      format.js   { render :locals => { :drain_list => drain_list } }
      format.json { 
        render :json => { :user_badge => render_to_string(:partial => 'user_badge.html.haml'),
                          :drain_list => drain_list}
      }
    end
  end
  
  private
  
  def get_my_drains
    if user_signed_in?
      @my_drains = current_user.drain_claims.includes(:drain).page(params[:page]).per(10)
    end
  end

  def get_drains_categories
    @clean = format_number(Drain.count(:conditions => 'cleared = true') )
    @unclean = format_number(Drain.count(:conditions => 'cleared = false'))
    @need_help = format_number(Drain.count(:conditions => 'need_help = true'))
    @all = format_number(Drain.count)

    @adopted = format_number(Drain.count(:conditions => 'claims_count > 0'))
    @not_adopted = format_number(Drain.count(:conditions => 'claims_count = 0'))

    puts "adopted #{@adopted}, #{@not_adopted}"

  end

  def format_number(number)
    formatted_number = number.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
    return formatted_number
  end


end
