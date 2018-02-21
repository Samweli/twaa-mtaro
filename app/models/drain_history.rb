class DrainHistory < ActiveRecord::Base
  attr_accessible :gid, :user_id, :drain_claim_id, :street_id, :priority_id,
                  :need_help, :cleared, :action
  belongs_to :drain
  belongs_to :drain_claim
  belongs_to :user
  belongs_to :street
  belongs_to :priority
end