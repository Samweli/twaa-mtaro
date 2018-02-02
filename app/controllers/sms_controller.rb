class SmsController < ApplicationController
	def new
		from_number = params['From']
		to_number = params['To']
		drain_status = params['Body']
		user_number = filter_number(from_number)

		# logic to updated drain
		# TODO to updated, to deal with users with many drains

		user = User.find_by_sms_number(user_number)
		sms_service = SmsService.new()
		message = sms_service.generate_message(user, drain_status)

        twiml = Twilio::TwiML::Response.new do |response|
        	response.Message message
	    end

	    render xml: twiml.to_xml, content_type:'text/xml'

	end

	private 

	def filter_number(number)
		if(number.include? '+')
			number = number.to_s.gsub!('+','');
		end		
		return number
	end

	# private 

	# def get_new_sms_response()
	# 	Twilio::TwiML::Response.new do |r|
	# 	  r.Say 'Asante'
	# 	end.text
	# end
end
