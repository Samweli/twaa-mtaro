require 'test_helper'

class SmsServiceTest < ActiveSupport::TestCase
  test 'should categorize message inputs' do
    message = 'Msafi#3'
    second_message = 'Msafi '

    sms_service = SmsService.new()

    output = sms_service.categorize_sms_content(message)
    second_output = sms_service.categorize_sms_content(second_message)

    expected_output = 'Msafi'
    second_expected_output = ['Msafi', '1']

    assert_equal output, expected_output
    # assert_equal second_output, second_expected_output
  end
end