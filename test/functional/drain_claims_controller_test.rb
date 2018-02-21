require 'test_helper'

class DrainClaimsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include TestStubHelper
  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]
    @user = users(:test)
    osm_geocode_api = "http://nominatim.openstreetmap.org/search"
    twillio_api = "https://api.twilio.com"
    drain_claims_stubs
    
 #    stub_request(:get, osm_geocode_api)
	#   .with(headers: {})
	#   .to_return(
	#     status: 200,
	#     body: "",
	#     headers: {}
	# )

	# stub_request(:post, twillio_api)
	#   .with(body: {}, headers: {})
	#   .to_return(
	#     status: 200,
	#     body: "",
	#     headers: {}
	# )
  end

  test 'should create drain claim' do
  	sign_in @user
    post :create, {:user_id => @user.id, :gid => 1}
    assert_response :redirect
  end

  test 'should update drain claim' do
  	sign_in @user
  	post :update , {:id => 1}
  	assert_response :redirect
  end

  test 'should list drain popup to anonymous user' do
    get :show, :id => 2
    assert_response :success
  end

  test 'should show drain adopt' do
    get :adopt
    assert_response :redirect
    # assert_template "drain_claims/adopt"
  end

  test 'should show drain user list' do
    get :user_list
    assert_response :redirect
    # assert_template "drain_claims/user_list"
  end

  test 'should destroy drain claim' do
    get :destroy, {:id => 1}
    assert_response :redirect
    # assert_template "drain_claims/show"
  end

end
