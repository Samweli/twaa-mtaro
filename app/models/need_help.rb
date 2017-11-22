class NeedHelp < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :gid, :help_needed, :user_id,:need_help_category_id
  validates_presence_of :gid, :user_id,:need_help_category_id
  belongs_to :drain
  belongs_to :user
  belongs_to :need_help_category
end
