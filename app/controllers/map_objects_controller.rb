class MapObjectsController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!, :except => [:show]
  
  layout 'info_window'

  def create
    unless @sidewalk = Sidewalk.find_by_gid(params[:gid])
      render :json => {:errors => 'Sidewalk error'}, :status => 500 and return
    end
    
    @map_object =
      MapObject.find_or_initialize_by_gid_and_object_type_and_source_type_and_source_id(
        @sidewalk.gid,
        MapObject::OBJECT_TYPES[:sidewalk],
        MapObject::SOURCE_TYPES[:user],
        current_user.id
    )
    
    success = true
    if @map_object.new_record?
      loc = Address.geocode("#{@sidewalk.address}, Chicago, IL")
      @map_object.lat = loc[0]
      @map_object.lng = loc[1]
      @map_object.claimed = true
      success = @map_object.save
    end
    
    if success
      redirect_to :action => :show, :id => @sidewalk.gid
    else
      render :json => {"errors" => @map_object.errors}, :status => 500
    end
  end

  def show
    @sidewalk = Sidewalk.find_by_gid(params[:id])
    @map_objects = @sidewalk.user_map_objects.all
    @sidewalk_status = analyze_sidewalk_status(@map_objects)
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
  
  def analyze_sidewalk_status(map_objects)
    s = { :people_adopted => [] }
    
    map_objects.each do |mo|
      s[:cleared] = true if mo.cleared
      s[:need_help] = true if mo.need_help
      
      if mo.source_id == current_user.id
        s[mo.claimed ? :adopted_by_me : :abandoned_by_me] = true
        s[:shoveled_by_me] = true if mo.claimed && mo.cleared
        s[:my_sidewalk] = mo
        s[:moid] = mo.id
      end
      
      s[:people_adopted] << mo.user.fullname if mo.claimed
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
