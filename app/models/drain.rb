class Drain < ActiveRecord::Base
  set_table_name 'mitaro_dar'

  has_many :claims, :class_name => 'DrainClaim', :foreign_key => "gid"
  has_many :need_helps, :class_name => 'NeedHelp', :foreign_key => "gid"
  has_and_belongs_to_many :streets
  has_many :wards, :through => :streets
  has_many :municipals, :through => :wards
  has_many :set_priorities
  has_many :priorities, through: :set_priorities

  validates_presence_of :lat, :lng
  
  include Geokit::Geocoders

  def self.find_all(limit=10000)
    query = %Q(
    SELECT s.*, ST_AsKML(the_geom) AS "kml" from mitaro_dar s LIMIT ?
    )

    find_by_sql([query,limit.to_i])
  end

  def self.where_custom(arg)
    if (arg.length == 1)
      column = arg.keys.join("") # this returns string instead of array
      column_value = arg.values
     
     # TODO replace "#{column}" with ? and add column variable in 
     # find_by_sql function 
      query = %Q(
      SELECT "mitaro_dar".*, ST_AsKML(the_geom) AS "kml" FROM mitaro_dar  
      WHERE  "#{column}" = ?
      )
      find_by_sql([query, column_value])
    else
      Rails.logger.debug(arg.keys[0], arg.keys[1])
      return
    end
  end

  def self.where_custom_conditions(condition, condition_value)
    query = %Q(
      SELECT "mitaro_dar".*, ST_AsKML(the_geom) AS "kml" FROM mitaro_dar  
      WHERE  "mitaro_dar"."#{condition}" #{condition_value} 
      )
      find_by_sql([query])
    # if (arg.length == 1)
    #   puts arg
    #   column = arg.keys.join("") # this returns string instead of array
    #   column_value = arg.values
     
    #  # TODO replace "#{column}" with ? and add column variable in 
    #  # find_by_sql function 
    #   query = %Q(
    #   SELECT "mitaro_dar".*, ST_AsKML(the_geom) AS "kml" FROM mitaro_dar  
    #   WHERE  "#{condition} #{condition_value}"  
    #   )
    #   find_by_sql([query,])
    # else
    #   return
    # end
  end

  def self.find_closest(lat, lng, limit=40, geo_buffer_size = 0.07)
    query = %Q(
    SELECT s.*, ST_AsKML(the_geom) AS "kml"
    FROM mitaro_dar s
    WHERE ST_Intersects(
      the_geom, 
      ST_Transform( 
        ST_Buffer( 
          ST_Transform( 
            ST_GeomFromEWKT('SRID=4326;POINT(? ?)'),
            3395
          ),
          ? + 2000
        ),
        4326
      )
    )
    LIMIT ?)
    
    find_by_sql([query, lng.to_f, lat.to_f, geo_buffer_size.to_f, limit.to_i])
  end
  
  def reverse_geocode
    @reverse_geocode ||= MultiGeocoder.reverse_geocode([lat, lng])
  end

  def street_number
    reverse_geocode.street_number
  end

  def street_name
    reverse_geocode.street_name
  end

  def street_address
    reverse_geocode.street_address
  end

  def city
    reverse_geocode.city
  end

  def state
    reverse_geocode.state
  end

  def zip
    reverse_geocode.zip
  end

  def country_code
    reverse_geocode.country_code
  end

  def country
    reverse_geocode.country
  end

  def full_address
    reverse_geocode.full_address
  end

  def priority?(priority)
    priorities.any? { |p| p.name.underscore.to_sym == priority }
  end

  def self.set_flood_prone(drain_id)
    set_flood_prone = SetPriority.new(:drain_id => drain_id, :priority_id => 1)
    set_flood_prone.save
  end


end
