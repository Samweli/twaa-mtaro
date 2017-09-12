require 'test_helper'

class NeedHelpCategoriesControllerTest < ActionController::TestCase
  setup do
    @need_help_category = need_help_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:need_help_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create need_help_category" do
    assert_difference('NeedHelpCategory.count') do
      post :create, need_help_category: { category_name: @need_help_category.category_name }
    end

    assert_redirected_to need_help_category_path(assigns(:need_help_category))
  end

  test "should show need_help_category" do
    get :show, id: @need_help_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @need_help_category
    assert_response :success
  end

  test "should update need_help_category" do
    put :update, id: @need_help_category, need_help_category: { category_name: @need_help_category.category_name }
    assert_redirected_to need_help_category_path(assigns(:need_help_category))
  end

  test "should destroy need_help_category" do
    assert_difference('NeedHelpCategory.count', -1) do
      delete :destroy, id: @need_help_category
    end

    assert_redirected_to need_help_categories_path
  end
end
