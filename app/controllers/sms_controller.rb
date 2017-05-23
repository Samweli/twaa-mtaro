class SmsController < ApplicationController
	def new
		from_number = params[:from]
		drain_status = params[:body]

		message = 'ujumbe'

		sidewalk = Sidewalk.find_by_user_phone_number(from_number)
	    unless sidewalk.blank?
	    	if (drain_status == 'msafi')
	    		sidewalk.cleared = true
	    		sidewalk.need_help = false
	    		if (sidewalk.save(validate: false))
	    			message = 'Asante, kwa kusafisha mtaro.'
	    		else
	    			message = 'Kuna tatizo upokeaji taarifa za mtaro,'
	    			           'Jaribu tena baadae'
	    		end
	    	end
	    else
	    	message = 'Samahani hatukuweza kutambua mtaro wako'
	  	end

		twiml = Twilio::TwiML::Response.new do |response|
	     response.Message message
	    end
	    render xml: twiml.to_xml, content_type:'text/xml'

	end

	# private 

	# def get_new_sms_response()
	# 	Twilio::TwiML::Response.new do |r|
	# 	  r.Say 'Asante'
	# 	end.text
	# end
end
