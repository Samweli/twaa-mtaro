class NeedHelp < ActiveRecord::Base
  attr_accessible :gid, :help_needed, :user_id
  validates_presence_of :gid, :user_id
  belongs_to :drain
  belongs_to :user
end
