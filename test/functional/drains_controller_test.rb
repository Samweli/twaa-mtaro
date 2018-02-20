require 'test_helper'

class DrainsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include TestStubHelper
  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]
    @user = users(:sleader)
    @drain = mitaro_dar(:one)
    drain_stubs
  end

  test 'should get index' do
    get :index, {:type => 'all', :format => :kml}
    assert_response :success
  end

  test 'should test drain updates' do
  	sign_in @user
  	post :update , {:id => 2, :shoveled => true}
  	assert_response :redirect
    # assert_template 'drain_claims/show'
    # assert_select 'h3' ,'Drain details'
  end

  test 'should test finding closest drains' do
    get :find_closest , {:lat => -6.79, :lng => 39.15 , :limit => 2}
    assert_response :missing
  end

  test 'should test setting flood prone to drain' do
    sign_in @user
    get :set_flood_prone , {:drain_id => 1}
    assert_response :success
  end
 
end