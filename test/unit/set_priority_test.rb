require 'test_helper'

class SetPriorityTest < ActiveSupport::TestCase
  should belong_to(:drain)
  should belong_to(:priority)
end
