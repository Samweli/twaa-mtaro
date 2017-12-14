class Ward < ActiveRecord::Base
  attr_accessible :ward_name, :municipal_id, :lat, :lng
  has_many :streets
  belongs_to :municipal

end
