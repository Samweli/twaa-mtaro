class DrainsController < ApplicationController
  respond_to :json
  # added :update in except for testing only, TO BE REMOVED
  before_filter :authenticate_user!, :except => [:index, :find_closest, :update]

  def index
    # check for the type of drains to query
    # TODO update all where_custom domain method to use
    # base where with select as Domain.where(conditions).select('columns')
    if params.has_key?(:type)
      if params[:type] == 'all'
        @drains = Drain.find_all(10000)
      else
        if params[:type] == 'cleaned'
          @drains = Drain.where_custom(:cleared => true)
        elsif params[:type] == 'uncleaned'
          @drains = Drain.where_custom(:cleared => false)
        elsif params[:type] == 'need_help'
          @drains = Drain.where_custom(:need_help => true)
        elsif params[:type] == 'unknown'
          @drains = Drain.where(:cleared => nil, :need_help => nil).
              select('*, ST_AsKML(the_geom) AS "kml"')
        elsif params[:type] == 'adopted'
          @drains = Drain.where_custom_conditions(:claims_count, "> 0")
        elsif params[:type] == 'not_adopted'
          @drains = Drain.where_custom_conditions(:claims_count, "= 0")
        elsif params[:type].include? "address"
          values = params[:type].split('=')
          value = values[1]
          if (value.to_i == 0)
            @drains = Drain.where_custom(:address => value)
          else
            @drains = Drain.where_custom(:gid => value)
          end
        end
      end

      unless @drains.blank?
        respond_with(@drains) do |format|
          format.kml {render}
        end
      else
        render :json => {:errors => {:address => [t("errors.not_found", :thing => t("defaults.thing"))]}}, :status => 404
      end
    else
      @drains = Drain.find_closest(params[:lat], params[:lng], params[:limit] || 10000)
      #puts "#{@drains.size} drains found for [#{params[:lat]}, #{params[:lng]}]"
      unless @drains.blank?
        respond_with(@drains) do |format|
          format.kml {render}
        end
      else
        render :json => {:errors => {:address => [t("errors.not_found", :thing => t("defaults.thing"))]}}, :status => 404
      end
    end
  end


  def find_closest
    gc = Address.geocode("#{params[:address]}, #{params[:city_state]}")

    render :json => {:errors => {:address => [t("errors.not_found", :thing => t("defaults.thing"))]}}, :status => 404 unless (gc && gc.success && gc.street_address)

    unless (drain = Drain.find_by_address(gc.street_address.upcase))
      drain = Drain.find_closest(gc.lat, gc.lng, 1, 0.02).first
    end
    render :json => {:gid => drain ? drain.gid : nil, :lat => gc.lat, :lng => gc.lng}
  end

  def update
    shoveled = (params.fetch(:shoveled, nil) == 'true' ? true : false)
    need_help = (params.fetch(:need_help, nil) == 'true' ? true : false)

    drain = Drain.find_by_gid(params[:id])
    sms_service = SmsService.new()
    user = current_user

    claim = drain.claims.find_by_user_id(user.id)
    street_leader = User.joins(:roles).where(roles: { id: 2 })
                        .find_by_street_id(user.street_id)

    if params.has_key?(:shoveled)

      status = (shoveled ? t("messages.clear_status") : t("messages.dirt_status"))

      if !(user.has_role(2))
        unless claim
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
        end

      else
        if claim
          claim.update_attribute(:shoveled, shoveled)
          claim.save(validate: false)
        end
        drain.cleared = shoveled
        drain.need_help = false if shoveled
        drain.save(validate: false)

        # check if it is street leader who is updating drain status
        if (user.id == street_leader.id)
          if claim
            claim.update_attribute(:shoveled, shoveled)
            claim.save(validate: false)
          end
        end

        reply_street_leader = t('messages.leader_notify', :id => drain.gid, :status => status)
        sms_service.send_sms(
            reply_street_leader,
            user.sms_number);

        if claim
          normal_user = User.find_by_id(claim.user_id)
          notify_user = t('messages.leader_to_user', :id => drain.gid, :status => status)
          sms_service.send_sms(
              notify_user,
              normal_user.sms_number);
        end

      end

    elsif params.has_key?(:need_help)
      drain.update_attribute(:need_help, need_help)
    end

    redirect_to :controller => :drain_claims, :action => :show, :id => params[:id]
  end

  def set_flood_prone
    Drain.set_flood_prone(params[:drain_id])
    render :json => {:success => true}
  end

end
