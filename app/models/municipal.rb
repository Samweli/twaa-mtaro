class Municipal < ActiveRecord::Base
  attr_accessible :city_name, :municipal_name
  has_many :wards
end
