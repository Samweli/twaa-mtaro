require 'test_helper'

class DrainTest < ActiveSupport::TestCase
  should have_many(:set_priorities)
  should have_many(:priorities).through(:set_priorities)
end
