require 'test_helper'

class DrainsControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index, :type => "all"
    puts @response.body
    assert_response :success
  end
end