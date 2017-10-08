class SmsService
  def initialize()
  	@account_sid = ENV['SMS_ACCOUNT_SID']
	@auth_token = ENV['SMS_AUTH_TOKEN']
	@client = Twilio::REST::Client.new @account_sid, @auth_token

  end

  def send_sms(content, tonumber)
	# set up a client to talk to the Twilio REST API
	tonumber = format(tonumber);
	
	@client.messages.create({
	  :from => '+14256540807',
	  :to => tonumber,
	  :body => content,
	})
  end

  def new_sms_updates(content, tonumber)
	# Loop over messages and print out a property for each one
	@client.messages.list.each do |message|
	puts message.body
	end
  end

  def get_new_sms_response()
	Twilio::TwiML::Response.new do |r|
	  r.Say 'Asante'
	end.text
  end

 #  Move here response logic from controller
 #  def sms_response(message)
 #  	twiml = Twilio::TwiML::Response.new do |response|
	#      response.Message message
	# end
	# return twiml
 #  end

  def format(number)
  	if number.to_s.include? '255' and not number.to_s.include? '+'
   	  number = "+#{number}"
   	end

   	return number
  end

  # Filter sent message content to get the sms params
  # Params: content String
  # returns: Array
  def categorize_sms_content(content)

  	content = content.strip

  	if (content.include? '#')
  		if(content.include? ' ')
  			updated_content = content.split(/\s*#\s*/)
  		else
  			updated_content = content.split('#')
  		end
  		if (updated_content.length == 1)
  			return updated_content[0].delete! ' #'
  		end
  		return updated_content
  	elsif (content.include? ' ')
  		split_content = content.split(/\s* \s*/)
  		if (split_content.length < 3)
  			return split_content 
  		else
  			return [split_content[0], split_content[1]]
  		end
	end
	return content
  end

  # Create the require response after updates in the model
  # Params: user User, drain_status Array or String
  # returns: String

  def generate_message(user, drain_status)
    message = ''
    if user
      drain_status = categorize_sms_content(drain_status)
      puts drain_status
      if(drain_status.instance_of?(Array))
        drain_id = drain_status[1]
        drain_status = drain_status[0]
        drain_claim = DrainClaim.find_by_user_id_and_gid(user.id, drain_id)
      else
        puts 'inside else'
        drain_claim = DrainClaim.find_by_user_id(user.id)
        puts drain_claim
        puts DrainClaim.all
        puts user.id
      end

      clean_keywords = ['msafi', 'Msafi', 'clean', 'Clean'].map(&:downcase)
      dirt_keywords = ['mchafu', 'Mchafu', 'dirty', 'Dirty',
       'not clean', 'Not clean'].map(&:downcase)
      need_help_keywords = ['msaada','Msaada', 'need_help', 'Need_help'].map(&:downcase)

      drain_status = drain_status.downcase

        unless drain_claim.blank?
          if (clean_keywords.include? drain_status)
            drain_claim.shoveled = true
            # drain.need_help = false
            message = I18n.t('messages.drain_cleaned')

          elsif (dirt_keywords.include? drain_status)
            drain_claim.shoveled = false
            # drain.need_help = false
            message = I18n.t('messages.drain_dirty')

          elsif (need_help_keywords.include? drain_status)
            drain_claim.shoveled = false
            # drain.need_help = true
            message = I18n.t('messages.thanks')
          else
            message = I18n.t('messages.unknown')
          end

          if (drain_claim.save(validate: false))

          else
            message = I18n.t('messages.error')
          end

        else
          message = I18n.t('messages.drain_unknown')
        end
    else
      message = I18n.t('messages.user_not_found', :site => I18n.t('defaults.site'));
    end

    return message
  end

  		

end