class SetPriority < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :drain
  belongs_to :priority
  # attr_accessible :title, :body
end
