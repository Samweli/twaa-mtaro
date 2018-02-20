require 'test_helper'

class DrainsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]
    @user = users(:sleader)
    @drain = mitaro_dar(:one)
    stubs
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


  def stubs
    stub_request(:get, "http://nominatim.openstreetmap.org/search?addressdetails=1&format=json&polygon=0&q=,%20").
    with(  headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})

     stub_request(:post, "https://api.twilio.com/2010-04-01/Accounts/AC12f20bfa2f6630b53c40266939dab38e/Messages.json").
    with(
      body: {"Body"=>"You have successfully updated drain with number 1 to flood prone.", "From"=>"14256540807", "To"=>"0655899266"},
      headers: {
      'Accept'=>'application/json',
      'Accept-Charset'=>'utf-8',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>'Basic QUMxMmYyMGJmYTJmNjYzMGI1M2M0MDI2NjkzOWRhYjM4ZTpjMmU0ZjEzODM1OGEzMDBmMDcwMzFjNzAyNmM5MzQxZg==',
      'Content-Type'=>'application/x-www-form-urlencoded',
      'User-Agent'=>'twilio-ruby/4.13.0 (ruby/x86_64-linux 2.2.3-p173)'
      }).
    to_return(status: 200, body: "", headers: {})


  end

 
end