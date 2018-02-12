class DrainClaimsController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!, :except => [:show]

  layout 'info_window'

  def create
    unless (@drain = Drain.find_by_gid(params[:gid]))
      render :json => {:errors => 'Drain not found'}, :status => 500 and return
    end
            # use id of drain as gid in drain claims table
    if (@claim = DrainClaim.find_or_initialize_by_gid_and_user_id_and_shoveled(@drain.gid, params[:user_id], @drain.try(:cleared))).new_record?
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

    sms_service = SmsService.new();
    if I18n.locale == :en
      msg = "You have been assigned drain with number #{@drain.gid} located at #{@drain.address}."
    else
      msg = "Umepewa mtaro wenye namba #{@drain.gid} unaopatikana #{@drain.address} kwa ajili ya usafi."
    end
    user = User.find_by_id(params[:user_id])

    sms_service.send_sms(
      msg, 
      user.sms_number);

    redirect_to :action => :show, :id => @drain.gid
  end

  def update
    shoveled = (params.fetch(:shoveled, nil) == 'true' ? true : false)

    drain = Drain.find_by_gid(params[:gid])
    sms_service = SmsService.new()
    user = current_user

    claim = DrainClaim.find(params[:id])
    street_leader = User.joins(:roles).where(roles: {id: 2})
                        .find_by_street_id(user.street_id)

    if params.has_key?(:shoveled)

      status = (shoveled ? t("messages.clear_status") : t("messages.dirt_status"))
      if !(user.has_role(2))
          claim.update_attribute(:shoveled, shoveled)
          claim.save(validate: false)

          reply_street_leader = t('messages.user_to_leader', :first_name => user.first_name,
                                  :last_name => user.last_name, :id => drain.gid, :status => status)
          notify_user = t('messages.user_notify', :id => drain.gid, :status => status)
          sms_service.send_sms(
              reply_street_leader,
              street_leader.sms_number)
          sms_service.send_sms(
              notify_user,
              user.sms_number)
      else
        if claim
          claim.update_attribute(:shoveled, shoveled)
          claim.save(validate: false)

          normal_user = User.find_by_id(claim.user_id)
          notify_user = t('messages.leader_to_user', :id => drain.gid, :status => status)
          sms_service.send_sms(
              notify_user,
              normal_user.sms_number);

          reply_street_leader = t('messages.leader_notify', :id => drain.gid, :status => status)
          sms_service.send_sms(
              reply_street_leader,
              user.sms_number);
        end
      end

    elsif params.has_key?(:need_help)
      drain.update_attribute(:need_help, need_help)
    end

    redirect_to :controller => :drain_claims, :action => :show, :id => params[:id]
  end

  def show
    @drain = Drain.find_by_gid(params[:id])
      # treat drain id as gid in drain_claims table
    claims = DrainClaim.where_custom(@drain.id)
    @my_drain =  DrainClaim.find_by_gid(@drain.id)
    @shoveled_by_me = true
    @claims = claims
    if @drain.need_help == true
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
