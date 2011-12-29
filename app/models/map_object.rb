class MapObject < ActiveRecord::Base
  belongs_to :user
  belongs_to :sidewalk, :foreign_key => "gid"
  has_many :reminders

  validates_presence_of :object_type, :source_type, :source_id, :gid
  
  SOURCE_TYPES = {
    :user => 0,
    :system => 1
  }.freeze

  OBJECT_TYPES = {
    :sidewalk => 0
  }.freeze

  #STATUSES = {
  #  :unclaimed => 0,
  #  :claimed => 1,
  #  :claimed_cleared => 2,
  #  :unclaimed_cleared => 3,
  #}.freeze

  def is_source_a?(source)
    source_type == SOURCE_TYPES[source]
  end
  
  def belongs_to_me?
    user_signed_in? && is_source_a?(:user) && current_user.id == source_id
  end
  
  def did_i_claim?
    belongs_to_me? && claimed
  end
  
  def did_i_clear?
    belongs_to_me? && cleared
  end
  
end
