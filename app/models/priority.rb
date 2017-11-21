class Priority < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true, uniqueness: true
  has_many :set_priorities
  has_many :drains, through: :set_priorities
end
