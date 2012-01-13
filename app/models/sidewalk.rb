class Sidewalk < ActiveRecord::Base
  set_table_name 'chicagosidewalks'
  
  has_many :claims, :class_name => 'SidewalkClaim', :foreign_key => "gid"
  validates_presence_of :lat, :lon
  
  include Geokit::Geocoders

  def self.find_closest(lat, lng, limit=40, geo_buffer_size = 0.07)
    query = %Q(
    SELECT s.*, ST_AsKML(the_geom) AS "kml"
    FROM chicagosidewalks s 
    WHERE ST_Intersects(
      the_geom, 
      ST_Transform( 
        ST_Buffer( 
          ST_Transform( 
            ST_GeomFromEWKT('SRID=4326;POINT(? ?)'),
            3395
          ),
          ? * 5280 * 0.3048
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
  




end
