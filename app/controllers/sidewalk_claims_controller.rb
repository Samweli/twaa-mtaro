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
    @map_object = current_user.user_map_objects.find_by_id(params[:id])
    update_bool_field :claimed
    update_bool_field :need_help
    update_bool_field :cleared
    
    MapObject.where(:gid => @map_object.gid).update_all(:need_help => false)
    
    if @map_object.save
      redirect_to :action => :show, :id => params[:gid]
    else
      render :json => {"errors" => @map_object.errors}, :status => 500
    end
  end
  
  private
  
  def analyze_sidewalk_status(claims)
    s = { :people_adopted => [], :people_cleared => [] }
    
    claims.each do |mo|
      if mo.source_id == current_user.id
        s[mo.claimed ? :adopted_by_me : :abandoned_by_me] = true
        s[:shoveled_by_me] = true if mo.claimed && mo.cleared
        s[:my_sidewalk] = mo
        s[:moid] = mo.id
      end
      
    end
    s
  end
  
  def update_bool_field(name)
    if params.has_key?(name)
      @map_object[name] = true if params[name] == 'true'
      @map_object[name] = false if params[name] == 'false'
    end
  end
end
