class DrainHistory < ActiveRecord::Base
  belongs_to :drain
  belongs_to :drain_claim
  belongs_to :user
  belongs_to :street
  belongs_to :priority
end