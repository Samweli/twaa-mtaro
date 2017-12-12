require 'test_helper'

class MunicipalsControllerTest < ActionController::TestCase
  setup do
    @municipal = municipals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:municipals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create municipal" do
    assert_difference('Municipal.count') do
      post :create, municipal: { city_name: @municipal.city_name, municipal_name: @municipal.municipal_name }
    end

    assert_redirected_to municipal_path(assigns(:municipal))
  end

  test "should show municipal" do
    get :show, id: @municipal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @municipal
    assert_response :success
  end

  test "should update municipal" do
    put :update, id: @municipal, municipal: { city_name: @municipal.city_name, municipal_name: @municipal.municipal_name }
    assert_redirected_to municipal_path(assigns(:municipal))
  end

  test "should destroy municipal" do
    assert_difference('Municipal.count', -1) do
      delete :destroy, id: @municipal
    end

    assert_redirected_to municipals_path
  end
end
