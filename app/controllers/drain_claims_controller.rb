class DrainClaimsController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!, :except => [:show]

  layout 'info_window'

  def create
    unless (@drain = Drain.find_by_gid(params[:gid]))
      render :json => {:errors => 'Drain not found'}, :status => 500 and return
    end
            # use id of drain as gid in drain claims table
    if (@claim = DrainClaim.find_or_initialize_by_gid_and_user_id(@drain.gid, params[:user_id])).new_record?
      if @drain.lat.nil?
        gc = Address.geocode("#{@drain.address}, Dar es salaam")
        if gc && gc.success
          @drain.lat = gc.lat
          @drain.lng = gc.lng
          @drain.save
        end
      end
      render :json => {:errors => @claim.errors}, :status => 500 and return unless @claim.save
    end

    #if params.fetch(:fb_publish, nil)
    #  message = <<-MSG
    #      I've adopted a drain to keep clear of snow this winter!
    #      Join www.ChicagoShovels.org to lend a hand, track snow plows,
    #      connect with neighbors and adopt-a-drain in your community      
    #  MSG
    #  
    #  publish_facebook_status(message)
    #end
    sms_service = SmsService.new();
    if I18n.locale == :en
      msg = "You have claimed drain number #{@drain.gid} located at #{@drain.address}"
    else
      msg = "Umetwaa mtaro number #{@drain.gid} unaopatikana #{@drain.address}"
    end
    user = User.find_by_id(params[:user_id])

    sms_service.send_sms(
      msg, 
      user.sms_number);

    redirect_to :action => :show, :id => @drain.gid
  end

  def show
    @drain = Drain.find_by_gid(params[:id])
      # treat drain id as gid in drain_claims table
    claims = DrainClaim.where_custom(@drain.id)
    @my_drain =  DrainClaim.find_by_gid(@drain.id)
    @shoveled_by_me = true
    @claims = claims
    if @drain.need_help == true
      Rails.logger.debug("This is the description #{@drain.need_helps}")
    end

    if user_signed_in?
      @claim_owner = DrainClaim.find_by_user_id_and_gid(current_user.id,params[:id])
    else
      @claim_owner =nil
    end




  end

  def adopt

    @street_users = Kaminari.paginate_array(
        User.find_all_by_street_id(current_user.street_id)
    ).page(params[:page]).per(2)
    render :adopt
  end

  def user_list
    @street_users = Kaminari.paginate_array(
        User.find_all_by_street_id(current_user.street_id)
    ).page(params[:page]).per(2)
    user_list = render_to_string :partial => 'user_list'

    respond_to do |format|
      format.js   { render :locals => { :user_list => user_list } }
      format.json {
        render :json => { :user_list => user_list}
      }
    end
  end

  def destroy
    @claim = DrainClaim.find(params[:id])
    @claim.destroy if @claim
    redirect_to :action => :show, :id => @claim.gid
  end

end
