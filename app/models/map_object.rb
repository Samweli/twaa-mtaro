class MapObject < ActiveRecord::Base
  belongs_to :user, :foreign_key => "source_id" #K: source_type filter here
  belongs_to :sidewalk, :foreign_key => "gid"
  has_many :reminders

  validates_presence_of :object_type, :source_type, :source_id, :gid
  validates_presence_of :lat, :lng
  
  include Geokit::Geocoders

  SOURCE_TYPES = {
    :user => 0,
    :system => 1
  }.freeze

  OBJECT_TYPES = {
    :sidewalk => 0
  }.freeze

  #STATUSES = {
  #  :unclaimed => 0,
  #  :claimed => 1,
  #  :claimed_cleared => 2,
  #  :unclaimed_cleared => 3,
  #}.freeze

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
  
  def is_source_a?(source)
    source_type == SOURCE_TYPES[source]
  end
  
  def belongs_to_me?
    is_source_a?(:user) && current_user.id == source_id
  end
  
  def did_i_claim?
    belongs_to_me? && claimed
  end
  
  def did_i_clear?
    belongs_to_me? && cleared
  end
  
end
