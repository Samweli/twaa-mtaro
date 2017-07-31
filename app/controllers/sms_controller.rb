class SmsController < ApplicationController
	def new
		from_number = params[:from]
		drain_status = params[:body]

		message = ''

		sidewalk = Sidewalk.find_by_user_phone_number(from_number)
	    unless sidewalk.blank?
	    	if (drain_status == 'msafi' or drain_status == 'Msafi' )
	    		sidewalk.cleared = true
	    		sidewalk.need_help = false
	    		message = 'Asante, kwa kusafisha mtaro.'

	    	elsif (drain_status == 'mchafu' or drain_status == 'Mchafu')
	    		sidewalk.cleared = false
	    		sidewalk.need_help = false
	    		message = 'Asante, kwa kutoa taarifa kuwa mtaro ni mchafu.'

	    	elsif (drain_status == 'msaada' or drain_status == 'Msaada')
	    		sidewalk.cleared = false
	    		sidewalk.need_help = true
	    	else
	    		message = 'Samahani hatukuweza kutambua maana ya ujumbe wako.'
	    	end

	    	if (sidewalk.save(validate: false))

	    	else
	    		message = 'Kuna tatizo upokeaji wa taarifa za mtaro, Jaribu tena baadae.'
	    	end

	    else
	    	message = 'Samahani hatukuweza kutambua mtaro wako.'
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
