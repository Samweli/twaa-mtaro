class SidewalkClaimsController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!, :except => [:show]

  layout 'info_window'

  def create
    unless (@sidewalk = Sidewalk.find_by_gid(params[:gid]))
      render :json => {:errors => 'Drain not found'}, :status => 500 and return
    end
            # use id of sidewalk as gid in sidewalk claims table
    if (@claim = SidewalkClaim.find_or_initialize_by_gid_and_user_id(@sidewalk.gid, params[:user_id])).new_record?
      if @sidewalk.lat.nil?
        gc = Address.geocode("#{@sidewalk.address}, Dar es salaam")
        if gc && gc.success
          @sidewalk.lat = gc.lat
          @sidewalk.lng = gc.lng
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
    sms_service = SmsService.new();
    if I18n.locale == :en
      msg = "You have claimed drain number #{@sidewalk.gid} located at #{@sidewalk.address}"
    else
      msg = "Umetwaa mtaro number #{@sidewalk.gid} unaopatikana #{@sidewalk.address}"
    end
    user = User.find_by_id(params[:user_id])

    sms_service.send_sms(
      msg, 
      user.sms_number);

    redirect_to :action => :show, :id => @sidewalk.gid
  end

  def show
    @sidewalk = Sidewalk.find_by_gid(params[:gid])
      # treat sidewalk id as gid in sidewalk_claims table
    claims = SidewalkClaim.where_custom(@sidewalk.gid)
    @my_sidewalk =  SidewalkClaim.find_by_gid(@sidewalk.gid)
    @shoveled_by_me = true
    @claims = claims



  end

  def adopt
    render :adopt
  end

  def destroy
    @claim = SidewalkClaim.find(params[:id])
    @claim.destroy if @claim
    redirect_to :action => :show, :id => @claim.gid
  end

end
