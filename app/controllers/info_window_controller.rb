class InfoWindowController < ApplicationController
  def index
    @map_object = MapObject.find_by_gid(params[:id])
    if @map_object.adopted?
      if user_signed_in? && current_user.id == @map_object.user_id
        render("users/thank_you")
      else
        render("users/profile")
      end
    else
      if user_signed_in?
        render("map_objects/adopt")
      else
        render("sessions/new")
      end
    end
  end
end
