class Ward < ActiveRecord::Base
  attr_accessible :ward_name
  belongs_to :municipal

end
