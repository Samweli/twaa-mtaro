class SidewalksController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!, :except => [:index]

  def index
    @sidewalks = Sidewalk.find_closest(params[:lat], params[:lng], params[:limit] || 40)
    unless @sidewalks.blank?
      respond_with(@sidewalks) do |format|
        format.kml { render }
      end
    else
      render :json => {"errors" => {"address" => [t("errors.not_found", :thing => t("defaults.thing"))]}}, :status => 404
    end
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
