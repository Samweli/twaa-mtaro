class MainController < ApplicationController
  def index
    if user_signed_in?
      @my_sidewalks = current_user.sidewalk_claims.includes(:sidewalk).all
    end
  end
end
