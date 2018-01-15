class Municipal < ActiveRecord::Base
  attr_accessible :city_name, :municipal_name, :lat, :lng
  has_many :wards
end
