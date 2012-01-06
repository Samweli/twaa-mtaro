class Sidewalk < ActiveRecord::Base
  set_table_name 'chicagosidewalks'
  
  has_many :map_objects, :foreign_key => "gid"

  #scope :user_map_objects, lambda {
  #  where(:gid => gid,
  #        :source_type => MapObject::SOURCE_TYPES[:user],
  #        :object_type => MapObject::OBJECT_TYPES[:sidewalk]).
  #  includes(:user)
  #}

  def self.find_closest(lat, lng, limit=40, geo_buffer_size = 0.05)
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

  def user_map_objects
    map_objects.
      where(:source_type => MapObject::SOURCE_TYPES[:user],
            :object_type => MapObject::OBJECT_TYPES[:sidewalk]).
      includes(:user)
  end
    
end
