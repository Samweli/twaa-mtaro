class SidewalkClaimsController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!, :except => [:show]
  
  layout 'info_window'

  def create
    unless (@sidewalk = Sidewalk.find_by_gid(params[:gid]))
      render :json => {:errors => 'Sidewalk not found'}, :status => 500 and return
    end
    
    if (current_user.claims_count && current_user.claims_count >= (current_user.max_claims || 100))
      err_msg = 'You have adopted a lot of sidewalks! If you would like to adopt more sidewalks, please send your request to ChicagoShovels@cityofchicago.org'
      
      #K: sent an email to chicagoshovels@cityofchicago.org to report this 100 max attempt
      
      render :json => {:errors => err_msg}, :status => 500 and return
    end
    
    if (@claim = SidewalkClaim.find_or_initialize_by_gid_and_user_id(@sidewalk.gid, current_user.id)).new_record?
      if @sidewalk.lat.nil?
        gc = Address.geocode("#{@sidewalk.address}, Chicago, IL")
        if gc && gc.success
          @sidewalk.lat = gc.lat
          @sidewalk.lon = gc.lng
          @sidewalk.save
        end
      end
      render :json => {:errors => @claim.errors}, :status => 500 and return unless @claim.save
    end
    
    #if params.fetch(:fb_publish, nil)
    #  message = <<-MSG
    #      I've adopted a sidewalk to keep clear of snow this winter!
    #      Join www.ChicagoShovels.org to lend a hand, track snow plows,
    #      connect with neighbors and adopt-a-sidewalk in your community      
    #  MSG
    #  
    #  publish_facebook_status(message)
    #end
    
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
