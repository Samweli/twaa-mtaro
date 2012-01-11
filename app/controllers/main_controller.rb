class MainController < ApplicationController
  #respond_to :html, :json
  def index
    if user_signed_in?
      @my_sidewalks = current_user.sidewalk_claims.includes(:sidewalk).all
    end

    respond_to do |format|
      format.html
      format.json {
        render :json => { :user_badge => render_to_string(:partial => 'user_badge.html.haml'),
                          :sidewalk_list => render_to_string(:partial => 'sidewalk_list.html.haml') }
      }
    end
  end
end
