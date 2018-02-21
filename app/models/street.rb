class Street < ActiveRecord::Base
   attr_accessible :street_name, :ward_id, :lat, :lng, :id
   validates_presence_of :street_name
   has_and_belongs_to_many :drains
   belongs_to :ward
   has_many :users
   has_many :drain_histories


end
