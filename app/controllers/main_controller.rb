class MainController < ApplicationController
  def index
    get_my_sidewalks
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
      @my_sidewalks = current_user.sidewalk_claims.includes(:sidewalk).page(params[:page]).per(10)
    end
  end

end
