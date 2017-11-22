require 'test_helper'

class PriorityTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)
  should have_many(:set_priorities)
  should have_many(:priorities).through(:set_priorities)
end
