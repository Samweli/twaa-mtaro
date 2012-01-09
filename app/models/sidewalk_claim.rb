class SidewalkClaim < ActiveRecord::Base
  belongs_to :user
  belongs_to :sidewalk

  validates_presence_of :user_id, :gid
  
end
