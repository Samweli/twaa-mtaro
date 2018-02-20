require 'test_helper'

#FIXME

class MainControllerTest < ActionController::TestCase

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should show terms of service' do
    get :tos
    assert_response :success
    assert_template 'main/tos'
    assert_select 'h2', 'Terms of Service'
  end

  
end
