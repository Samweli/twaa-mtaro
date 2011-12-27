class MapObjectsController < ApplicationController
  respond_to :html, :json

  def show
    @map_object = MapObject.find_by_gid(params[:id])

    respond_with @map_object    
    #if @map_object.adopted?
    #  if user_signed_in? && current_user.id == @map_object.user_id
    #    render("users/thank_you")
    #  else
    #    render("users/profile")
    #  end
    #else
    #  if user_signed_in?
    #    render("map_objects/adopt")
    #  else
    #    render("sessions/new")
    #  end
    #end

  end

  def update
    @map_object = MapObject.find(params[:id])
    if @map_object.update_attributes(params[:thing])
      respond_with @map_object
    else
      render(:json => {"errors" => @map_object.errors}, :status => 500)
    end
  end
end
