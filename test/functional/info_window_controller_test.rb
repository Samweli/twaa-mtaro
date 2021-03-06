require 'test_helper'

# FIXME

class InfoWindowControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @drain = mitaro_dar(:one)
    @user = users(:test)
  end

  test 'should thank the user if the user the drain is adopted by the user' do
    sign_in @user
    @drain.user_id = @user.id
    @drain.save!
    get :index, :drain_id => @drain.id
    assert_not_nil assigns :drain
    assert_response :success
    assert_template 'users/thank_you'
    assert_select 'h2', 'Thank you for adopting this drain!' # FIXME
    assert_select 'form#edit_profile_form' do
      assert_select '[action=?]', '/users/edit'
      assert_select '[method=?]', 'get'
    end
    assert_select 'input[name="commit"]' do
      assert_select '[type=?]', 'submit'
      assert_select '[value=?]', 'Edit profile'
    end
    assert_select 'form#abandon_form' do
      assert_select '[action=?]', "/drains"
      assert_select '[method=?]', 'post'
    end
    assert_select 'input[name="_method"]' do
      assert_select '[type=?]', 'hidden'
      assert_select '[value=?]', 'put'
    end
    assert_select 'input[name="commit"]' do
      assert_select '[type=?]', 'submit'
      assert_select '[value=?]', 'Abandon this drain'
    end
    assert_select 'form#sign_out_form' do
      assert_select '[action=?]', '/info_window'
      assert_select '[method=?]', 'post'
    end
    assert_select 'input[name="commit"]' do
      assert_select '[type=?]', 'submit'
      assert_select '[value=?]', 'Sign out'
    end
  end

  test 'should show the profile if the drain is adopted' do
    @drain.user_id = @user.id
    @drain.save!
    get :index, :drain_id => @drain.id
    assert_not_nil assigns :drain
    assert_response :success
    assert_template 'users/profile'
    assert_select 'h2', /This drain has been adopted\s+by #{@user.name}\s+of #{@user.organization}/ # FIXME
  end

  test 'should show adoption form if drain is not adopted' do
    sign_in @user
    get :index, :drain_id => @drain.id
    assert_not_nil assigns :drain
    assert_response :success
    assert_template :adopt
    assert_select 'h2', 'Adopt this Drain'
    assert_select 'form#adoption_form' do
      assert_select '[action=?]', "/drains"
      assert_select '[method=?]', 'post'
    end
    assert_select 'input[name="_method"]' do
      assert_select '[type=?]', 'hidden'
      assert_select '[value=?]', 'put'
    end
    assert_select 'input[name="commit"]' do
      assert_select '[type=?]', 'submit'
      assert_select '[value=?]', 'Adopt!'
    end
    assert_select 'form#edit_profile_form' do
      assert_select '[action=?]', '/users/edit'
      assert_select '[method=?]', 'get'
    end
    assert_select 'input[name="commit"]' do
      assert_select '[type=?]', 'submit'
      assert_select '[value=?]', 'Edit profile'
    end
    assert_select 'form#sign_out_form' do
      assert_select '[action=?]', '/info_window'
      assert_select '[method=?]', 'post'
    end
    assert_select 'input[name="commit"]' do
      assert_select '[type=?]', 'submit'
      assert_select '[value=?]', 'Sign out'
    end
  end

  test 'should show sign-in form if signed out' do
    get :index, :drain_id => @drain.id
    assert_not_nil assigns :drain
    assert_response :success
    assert_template 'sessions/new'
    assert_select 'form#combo_form' do
      assert_select '[action=?]', '/info_window'
      assert_select '[method=?]', 'post'
    end
    assert_select 'h2', 'Adopt this Drain'
    assert_select 'input', :count => 15
    assert_select 'label', :count => 10
    assert_select 'input[name="commit"]', :count => 3
  end

  test 'should show terms of service' do
    get :tos
    assert_response :success
    assert_template 'info_window/tos'
    assert_select 'h2', 'Terms of Service'
  end
end
