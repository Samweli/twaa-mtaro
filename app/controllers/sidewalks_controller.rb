class SidewalksController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!, :except => [:index, :find_closest]

  def index
    @sidewalks = Sidewalk.find_closest(params[:lat], params[:lng], params[:limit] || 100)
    #puts "#{@sidewalks.size} sidewalks found for [#{params[:lat]}, #{params[:lng]}]"
    unless @sidewalks.blank?
      respond_with(@sidewalks) do |format|
        format.kml { render }
      end
    else
      render :json => {:errors => {:address => [t("errors.not_found", :thing => t("defaults.thing"))]}}, :status => 404
    end
  end

  def find_closest
    gc = Address.geocode("#{params[:address]}, #{params[:city_state]}")
    
    render :json => {:errors => {:address => [t("errors.not_found", :thing => t("defaults.thing"))]}}, :status => 404 unless (gc && gc.success && gc.street_address)

    unless (sidewalk = Sidewalk.find_by_address(gc.street_address.upcase))
      sidewalk = Sidewalk.find_closest(gc.lat, gc.lng, 1, 0.02).first
    end
    render :json => {:gid => sidewalk ? sidewalk.gid : nil, :lat => gc.lat, :lng => gc.lng}
  end

  def update
    shoveled = (params.fetch(:shoveled, nil) == 'true' ? true : false)
    need_help = (params.fetch(:need_help, nil) == 'true' ? true : false)
    
    sidewalk = Sidewalk.find_by_gid(params[:id])
  
    if params.has_key?(:shoveled)
      sidewalk.cleared = shoveled
      sidewalk.need_help = false if shoveled
      sidewalk.save
      
      if (claim = sidewalk.claims.find_by_user_id(current_user.id))
        claim.update_attribute(:shoveled, shoveled)
      end
    elsif params.has_key?(:need_help)
      sidewalk.update_attribute(:need_help, need_help)
    end
    
    redirect_to :controller => :sidewalk_claims, :action => :show, :id => params[:id]
  end
  


end
