class MainController < ApplicationController
  #respond_to :html, :json
  def index
    if user_signed_in?
      @my_sidewalks = current_user.sidewalk_claims.includes(:sidewalk).page(params[:page]).per(10)
    end

    sidewalk_list = render_to_string :partial => 'sidewalk_list.html.haml'

    respond_to do |format|
      format.html
      format.js   { render :locals => { :sidewalk_list => sidewalk_list } }
      format.json { 
        render :json => { :user_badge => render_to_string(:partial => 'user_badge.html.haml'),
                          :sidewalk_list => sidewalk_list}
      }
    end
  end
end
