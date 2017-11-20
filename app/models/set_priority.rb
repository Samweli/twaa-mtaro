class SetPriority < ActiveRecord::Base
  belongs_to :drain
  belongs_to :priority
  # attr_accessible :title, :body
end
