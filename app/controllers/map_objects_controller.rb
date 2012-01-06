class MapObjectsController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!, :except => [:show]
  
  layout 'info_window'

  def create
    @sidewalk = Sidewalk.find_by_gid(params[:id])
    @map_object =
      MapObject.find_or_initialize_by_gid_and_claimed_and_object_type_and_source_type_and_source_id(
        params[:id],
        true,
        MapObject::OBJECT_TYPES[:sidewalk],
        MapObject::SOURCE_TYPES[:user],
        current_user.id
    )
    
    success = true
    if @map_object.new_record?
      loc = Address.geocode("#{@sidewalk.address}, Chicago, IL")
      @map_object.lat = loc[0]
      @map_object.lng = loc[1]
      success = @map_object.save
    end
    
    if success
      redirect_to :action => :show, :id => params[:id]
    else
      render(:json => {"errors" => @map_object.errors}, :status => 500)
    end
  end

  def show
    @sidewalk = Sidewalk.find_by_gid(params[:id])
    @map_objects = @sidewalk.user_map_objects.all
    populate_sidewalk_status
  end

  def update
    @map_object = current_user.user_map_objects.find_by_id(params[:id])
    puts "Update MOID: #{@map_object.id}"
    
    success = true
    
    if success
      redirect_to :action => :show, :id => params[:id]
    else
      render(:json => {"errors" => @map_object.errors}, :status => 500)
    end
  end
  
  private
  
  def populate_sidewalk_status
    @sidewalk_status = {}
    @map_objects.each do |mo|
      @sidewalk_status[:cleared] = true if mo.cleared
      @sidewalk_status[:need_help] = true if mo.need_help
      
      if mo.claimed && mo.source_id == current_user.id
        @sidewalk_status[:adopted_by_me] = true
        @sidewalk_status[:my_sidewalk] = mo
      end
    end
  end
  
end
