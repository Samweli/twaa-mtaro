class SmsController < ApplicationController
	def new
		from_number = params[:from]
		to_number = params[:to]
		drain_status = params[:body]
		user_number = filter_number(from_number)

		message = ''
		# logic to updated drain
		# TODO to updated, to deal with users with many drains

		user = User.find_by_sms_number(user_number)

		if user
			drain_claim = DrainClaim.find_by_user_id(user.id)

			clean_keywords = ['msafi', 'Msafi', 'clean', 'Clean'].map(&:downcase)
			dirt_keywords = ['mchafu', 'Mchafu', 'dirty', 'Dirty',
			 'not clean', 'Not clean'].map(&:downcase)
			need_help_keywords = ['msaada','Msaada', 'need_help', 'Need_help'].map(&:downcase)

			drain_status = drain_status.downcase

		    unless drain_claim.blank?
		    	if (clean_keywords.include? drain_status)
		    		drain_claim.shoveled = true
		    		# drain.need_help = false
		    		message = t('messages.drain_cleaned')

		    	elsif (dirt_keywords.include? drain_status)
		    		drain_claim.shoveled = false
		    		# drain.need_help = false
		    		message = t('messages.drain_dirty')

		    	elsif (need_help_keywords.include? drain_status)
		    		drain_claim.shoveled = false
		    		# drain.need_help = true
		    		message = t('messages.thanks')
		    	else
		    		message = t('messages.unknown')
		    	end

		    	if (drain_claim.save(validate: false))

		    	else
		    		message = t('messages.error')
		    	end

		    else
		    	message = t('messages.drain_unknown')
		  	end
		else
			message = t('message.user_not_found')
		end

        twiml = Twilio::TwiML::Response.new do |response|
        	response.Message message
	    end

	    render xml: twiml.to_xml, content_type:'text/xml'

	end

	private 

	def filter_number(number)
		number = number.to_s.gsub!('+','');
		return number
	end

	# private 

	# def get_new_sms_response()
	# 	Twilio::TwiML::Response.new do |r|
	# 	  r.Say 'Asante'
	# 	end.text
	# end
end
