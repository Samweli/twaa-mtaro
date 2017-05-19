class SmsController < ApplicationController
	def new
		
		twiml = Twilio::TwiML::Response.new do |response|
	     response.Say "Asante"
	    end
	    render xml: twiml.to_xml, content_type:'text/xml'

		# sidewalk = Sidewalk.find_by_user_phone_number(from_number)

		# if (sidewalk_status == 'msafi')
		# 	sidewalk.cleared = true
		# 	sidewalk.need_help = false

  #     		sidewalk.save(validate: false)	
  #     	end

	end

	# private 

	# def get_new_sms_response()
	# 	Twilio::TwiML::Response.new do |r|
	# 	  r.Say 'Asante'
	# 	end.text
	# end
end
