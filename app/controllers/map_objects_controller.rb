class MapObjectsController < ApplicationController
  respond_to :json

  def show
    @map_objects = MapObject.find_closest(params[:lat], params[:lng], params[:limit] || 40)
    unless @map_objects.blank?
      respond_with(@map_objects) do |format|
        format.kml { render }
      end
    else
      render(:json => {"errors" => {"address" => [t("errors.not_found", :thing => t("defaults.thing"))]}}, :status => 404)
    end
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
