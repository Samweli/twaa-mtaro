require 'test_helper'

class SmsServiceTest < ActiveSupport::TestCase
  setup do
    @user = users(:edward)
    @drain = drains(:one)
    # @drain_claim_1 = drain_claims(:one)

    # @drain_claim_1.gid = @drain_1.gid
    # @drain_claim_1.user_id = @user.id

    # @drain_claim_1.save
  end

  test 'should categorize message inputs' do
    message = 'Msafi# 3'
    second_message = 'Msafi '

    sms_service = SmsService.new()

    output = sms_service.categorize_sms_content(message)
    second_output = sms_service.categorize_sms_content(second_message)

    expected_output = 'Msafi'
    second_expected_output = ['Msafi', '1']

    assert_equal output, expected_output
    # assert_equal second_output, second_expected_output
  end

  test 'should generate response message' do
    # post :new, {'From':,'To':,'Body':,}
    sms_service = SmsService.new()
    output = sms_service.generate_message(@user, 'Msafi')
    expected_output = "Thanks for cleaning your drain."
    
    assert_equal output, expected_output
  end
end