class MapObjectsController < ApplicationController
  respond_to :html, :json

  def index
  end

  def new
    find_object
    
    if user_signed_in?
      if @map_object.is_source_a? :user &&
        current_user.id == @map_object.source_id
        # trying to adopt an object that I already adopted
      else
        # adopt this object now
      end
    else
      render 'users/new'
    end
  end

  def show
    find_object
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
  
  private
  
  def find_object
    @map_object = MapObject.find_by_gid(params[:id])
  end
end
