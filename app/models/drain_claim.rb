class DrainClaim < ActiveRecord::Base
  belongs_to :user, :counter_cache => :claims_count
  belongs_to :sidewalk, :counter_cache => :claims_count, :foreign_key => 'gid'

  validates_presence_of :user_id, :gid


  def self.where_custom(arg)
    
    query = %Q(
      SELECT "drain_claims".* FROM "drain_claims" WHERE "drain_claims"."gid" IN (?)

      )
    find_by_sql([query, arg])
  end

end
