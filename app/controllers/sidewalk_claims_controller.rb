class SidewalkClaimsController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!, :except => [:show]
  
  layout 'info_window'

  def create
    unless (@sidewalk = Sidewalk.find_by_gid(params[:gid]))
      render :json => {:errors => 'Sidewalk not found'}, :status => 500 and return
    end
    
    if current_user.sidewalk_claims.count >= 100
      render :json => {:errors => 'You can adopt max 100 sidewalks'}, :status => 500 and return
    end
    
    if (@claim = SidewalkClaim.find_or_initialize_by_gid_and_user_id(@sidewalk.gid, current_user.id)).new_record?
      if @sidewalk.lat.nil?
        loc = Address.geocode("#{@sidewalk.address}, Chicago, IL")
        @sidewalk.lat = loc[0]
        @sidewalk.lon = loc[1]
        @sidewalk.save
      end
      render :json => {"errors" => @claim.errors}, :status => 500 and return unless @claim.save
    end
    
    if params.fetch(:fb_publish, nil)
      message = <<-MSG
          I've adopted a sidewalk to keep clear of snow this winter!
          Join www.ChicagoShovels.org to lend a hand, track snow plows,
          connect with neighbors and adopt-a-sidewalk in your community      
      MSG
      
      publish_facebook_status(message)
    end
    
    redirect_to :action => :show, :id => @sidewalk.gid
  end

  def show
    @sidewalk = Sidewalk.find_by_gid(params[:id])
    claims = @sidewalk.claims.includes(:user)
    @my_sidewalk = user_signed_in? ? claims.find_by_user_id(current_user.id) : nil
    @shoveled_by_me = @sidewalk.cleared && @my_sidewalk && @my_sidewalk.shoveled
    @claims = claims.all
  end

  def destroy
    @claim = SidewalkClaim.find(params[:id])
    @claim.destroy if @claim
    redirect_to :action => :show, :id => @claim.gid
  end
  
end
