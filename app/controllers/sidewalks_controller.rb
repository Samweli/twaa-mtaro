class SidewalksController < ApplicationController
  respond_to :json
  # added :update in except for testing only, TO BE REMOVED
  before_filter :authenticate_user!, :except => [:index, :find_closest, :update]

  def index
    # check for the type of drains to query
    if params.has_key?(:type)
      if params[:type] == 'all'
        @sidewalks = Sidewalk.find_all(10000)
      else
        if params[:type] == 'cleaned'
          @sidewalks = Sidewalk.where_custom(:cleared => true)
        elsif params[:type] == 'uncleaned'
          @sidewalks = Sidewalk.where_custom(:cleared => false)
        elsif params[:type] == 'need_help'
          @sidewalks = Sidewalk.where_custom(:need_help => true)
        elsif params[:type].include? "address"
          values = params[:type].split('=')
          value = values[1]
          puts value
          @sidewalks = Sidewalk.where_custom(:address => value)
        end
      end

      unless @sidewalks.blank?
        respond_with(@sidewalks) do |format|
          format.kml {render}
        end
      else
        render :json => {:errors => {:address => [t("errors.not_found", :thing => t("defaults.thing"))]}}, :status => 404
      end
    else
      @sidewalks = Sidewalk.find_closest(params[:lat], params[:lng], params[:limit] || 10000)
      #puts "#{@sidewalks.size} sidewalks found for [#{params[:lat]}, #{params[:lng]}]"
      unless @sidewalks.blank?
        respond_with(@sidewalks) do |format|
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

    unless (sidewalk = Sidewalk.find_by_address(gc.street_address.upcase))
      sidewalk = Sidewalk.find_closest(gc.lat, gc.lng, 1, 0.02).first
    end
    render :json => {:gid => sidewalk ? sidewalk.gid : nil, :lat => gc.lat, :lng => gc.lng}
  end

  def update
    shoveled = (params.fetch(:shoveled, nil) == 'true' ? true : false)
    need_help = (params.fetch(:need_help, nil) == 'true' ? true : false)

    sidewalk = Sidewalk.find_by_gid(params[:id])
    sms_service = SmsService.new()

    if params.has_key?(:shoveled)
      sidewalk.cleared = shoveled
      sidewalk.need_help = false if shoveled
      sidewalk.save(validate: false)

      status = (shoveled ? [t("messages.clear_status")] : [t("message.dirt_status")])

      reply_street_leader = "Umeuwekea alama ya mtaro namba #{sidewalk.gid} kuwa #{status}"
      notify_user = "Kiongozi wa mtaa abadilisha alama ya mtaro wako, namba #{sidewalk.gid} #{status}"

      # sms_service.send_sms(
      #   reply_street_leader, 
      #   '+255655899266');
      # sms_service.send_sms(
      #   notify_user, 
      #   '+255655899266');

      # if (claim = sidewalk.claims.find_by_user_id(current_user.id))
      #   claim.update_attribute(:shoveled, shoveled)
      # end
    elsif params.has_key?(:need_help)
      sidewalk.update_attribute(:need_help, need_help)
    end

    redirect_to :controller => :sidewalk_claims, :action => :show, :id => params[:id]
  end


end
