require 'test_helper'

class NeedHelpsControllerTest < ActionController::TestCase
  setup do
    @need_help = need_helps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:need_helps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create need_help" do
    assert_difference('NeedHelp.count') do
      post :create, need_help: { gid: @need_help.gid, help_needed: @need_help.help_needed, user_id: @need_help.user_id }
    end

    assert_redirected_to need_help_path(assigns(:need_help))
  end

  test "should show need_help" do
    get :show, id: @need_help
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @need_help
    assert_response :success
  end

  test "should update need_help" do
    put :update, id: @need_help, need_help: { gid: @need_help.gid, help_needed: @need_help.help_needed, user_id: @need_help.user_id }
    assert_redirected_to need_help_path(assigns(:need_help))
  end

  test "should destroy need_help" do
    assert_difference('NeedHelp.count', -1) do
      delete :destroy, id: @need_help
    end

    assert_redirected_to need_helps_path
  end
end
