class Ward < ActiveRecord::Base
  attr_accessible :ward_name, :municipal_id, :lat, :lng
  belongs_to :municipal

end
