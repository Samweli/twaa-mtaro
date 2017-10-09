require 'test_helper'

class SmsControllerTest < ActionController::TestCase
  setup do
    @user = users(:edward)
  end

  # test 'should generate response message' do
  #   # post :new, {'From':,'To':,'Body':,}
  #   @controller = SmsController.new
  #   @controller.instance_eval{ generate_message(@user, 'Msafi') }   # invoke the private method
  #   assert_equal @controller.instance_eval{ generate_message(@user, 'Msafi') },"Thanks for cleaning your drain."
  # end
end