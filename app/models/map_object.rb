class MapObject < ActiveRecord::Base
  belongs_to :user
  has_many :reminders

  SOURCE_TYPES = {
    :user => 0,
    :system => 1
  }.freeze

  def is_source_a?(source)
    source_type == SOURCE_TYPES[source]
  end
  
  def adopted?
    false
    #!user_id.nil?
  end
end
