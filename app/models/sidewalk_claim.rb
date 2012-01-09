class SidewalkClaim < ActiveRecord::Base
  belongs_to :user
  belongs_to :sidewalk, :counter_cache => :num_adopted

  validates_presence_of :user_id, :gid
  
end
