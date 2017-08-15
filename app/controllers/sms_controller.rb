class SmsController < ApplicationController
	def new
		from_number = params[:from]
		drain_status = params[:body]

		message = ''

		drain = Drain.find_by_user_phone_number(from_number)
		clean_keywords = ['msafi', 'Msafi', 'clean', 'Clean'].map(&:downcase)
		dirt_keywords = ['mchafu', 'Mchafu', 'dirty', 'Dirty',
		 'not clean', 'Not clean'].map(&:downcase)
		need_help_keywords = ['msaada','Msaada', 'need_help', 'Need_help'].map(&:downcase)

		drain_status = drain_status.downcase

	    unless drain.blank?
	    	if (clean_keywords.include? drain_status)
	    		drain.cleared = true
	    		drain.need_help = false
	    		message = t('messages.drain_cleaned')

	    	elsif (dirt_keywords.include? drain_status)
	    		drain.cleared = false
	    		drain.need_help = false
	    		message = t('messages.drain_dirty')

	    	elsif (need_help_keywords.include? drain_status)
	    		drain.cleared = false
	    		drain.need_help = true
	    		message = t('messages.thanks')
	    	else
	    		message = t('messages.unknown')
	    	end

	    	if (drain.save(validate: false))

	    	else
	    		message = t('messages.error')
	    	end

	    else
	    	message = t('messages.drain_unknown')
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
