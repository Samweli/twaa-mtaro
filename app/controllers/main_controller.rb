class MainController < ApplicationController
  def index
    get_my_sidewalks
    get_sidewalks_categories
  end

  def sidebar
    get_my_sidewalks
    sidewalk_list = render_to_string :partial => 'sidewalk_list.html.haml'

    respond_to do |format|
      format.js   { render :locals => { :sidewalk_list => sidewalk_list } }
      format.json { 
        render :json => { :user_badge => render_to_string(:partial => 'user_badge.html.haml'),
                          :sidewalk_list => sidewalk_list}
      }
    end
  end
  

  private
  
  def get_my_sidewalks
    if user_signed_in?
      @my_sidewalks = current_user.drain_claims.includes(:sidewalk).page(params[:page]).per(10)
    end
  end

  def get_sidewalks_categories
    @clean = format_number(Sidewalk.count(:conditions => 'cleared = true') )
    @unclean = format_number(Sidewalk.count(:conditions => 'cleared = false'))
    @need_help = format_number(Sidewalk.count(:conditions => 'need_help = true'))
    @all = format_number(Sidewalk.count)
  end

  def format_number(number)
    formatted_number = number.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
    return formatted_number
  end


end
