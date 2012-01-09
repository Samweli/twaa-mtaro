class SidewalksController < ApplicationController
  respond_to :json

  def show
    @sidewalks = Sidewalk.find_closest(params[:lat], params[:lng], params[:limit] || 40)
    unless @sidewalks.blank?
      respond_with(@sidewalks) do |format|
        format.kml { render }
      end
    else
      render :json => {"errors" => {"address" => [t("errors.not_found", :thing => t("defaults.thing"))]}}, :status => 404
    end
  end



end
