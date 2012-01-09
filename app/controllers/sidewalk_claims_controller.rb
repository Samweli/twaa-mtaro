class SidewalkClaimsController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!, :except => [:show]
  
  layout 'info_window'

  def create
    render :json => {:errors => 'Sidewalk not found'}, :status => 500 and return
      unless @sidewalk = Sidewalk.find_by_gid(params[:gid])
    
    if (@claim = SidewalkClaim.find_or_initialize_by_gid_and_user_id(@sidewalk.gid, current_user.id)).new_record?
      if @sidewalk.lat.nil?
        loc = Address.geocode("#{@sidewalk.address}, Chicago, IL")
        @sidewalk.lat = loc[0]
        @sidewalk.lon = loc[1]
        @sidewalk.save
      end
      render :json => {"errors" => @claim.errors}, :status => 500 and return unless @claim.save
    end
    
    redirect_to :action => :show, :id => @sidewalk.gid
  end

  def show
    @sidewalk = Sidewalk.find_by_gid(params[:id])
    claims = @sidewalk.claims.includes(:user)
    @my_sidewalk = claims.find_by_user_id(current_user.id)
    @shoveled_by_me = @sidewalk.cleared && @my_sidewalk && @my_sidewalk.shoveled
    @claims = claims.all
  end

  def update
    @claim = current_user.sidewalk_claims.find_by_id(params[:id])
    shoveled = (params.fetch(:shoveled) == 'true' ? true : false)
    @claim.sidewalk.update_attributes(:cleared => true, :need_help => false) if shoveled
    @claim.update_attribute(:shoveled, shoveled)
    redirect_to :action => :show, :id => params[:gid]
  end
  
  def destroy
    @claim = SidewalkClaim.find(params[:id])
    @claim.destroy if @claim
    redirect_to :action => :show, :id => @claim.gid
  end
  
end
