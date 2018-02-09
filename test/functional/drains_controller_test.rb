require 'test_helper'

class DrainsControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index, {:type => 'all', :format => :json}
    puts @response.body
    assert_response :success
  end
end