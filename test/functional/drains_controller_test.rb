require 'test_helper'

class DrainsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]
    @user = users(:test)
  end

  test 'should get index' do
    get :index, {:type => 'all', :format => :kml}
    assert_response :success
  end

  test 'should test drain updates' do
  	sign_in @user
  	post :update , {:id => 2}
  	assert_response :redirect
  end
end