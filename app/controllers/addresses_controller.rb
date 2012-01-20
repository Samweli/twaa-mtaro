class AddressesController < ApplicationController
  respond_to :json

  def show
    gc = Address.geocode("#{params[:address]}, #{params[:city_state]}")
    
    if gc && gc.success
      respond_with [gc.lat, gc.lng]
    else
      render(:json => {"errors" => {"address" => [t("errors.not_found", :thing => t("defaults.address"))]}}, :status => 404)
    end
  end
  
  private
  
  def update_location
    
  end
end
