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
	Rails.logger.debug(message.body)
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
    clean_keywords = ['msafi', 'Msafi', 'clean', 'Clean'].map(&:downcase)
    dirt_keywords = ['mchafu', 'Mchafu', 'dirty', 'Dirty',
       'not clean', 'Not clean'].map(&:downcase)
    need_help_keywords = ['msaada','Msaada', 'need help', 'Need help'].map(&:downcase)
    street_leader = User.find_by_role_and_street_id(2, user.street_id)

    if user
      drain_status = categorize_sms_content(drain_status)
      if(drain_status.instance_of?(Array))
        drain_id = drain_status[1]
        drain_status = drain_status[0]
        drain_claim = DrainClaim.find_by_user_id_and_gid(user.id, drain_id)
      else
        drain_claim = DrainClaim.where(:user_id => user.id)
        if (!drain_claim.instance_of?(DrainClaim))
          #TODO function to determine user language
          I18n.locale = 'sw'
          message = I18n.t('messages.many_drains')
          I18n.locale = 'en'
          message = message + "   " + I18n.t('messages.many_drains')
          return message
        end
      end
      drain_status = drain_status.downcase

        unless drain_claim.blank?
          if (clean_keywords.include? drain_status)
            change_locale(clean_keywords, drain_status)
            drain_claim.shoveled = true
            if(user.id == street_leader.id)
              drain = Drain.find_by_gid(drain_claim.try(:gid))
              drain.cleared = true
              drain.save(validate: false)
            end
            # drain.need_help = false
            message = I18n.t('messages.drain_cleaned')

          elsif (dirt_keywords.include? drain_status)
            change_locale(dirt_keywords, drain_status)
            drain_claim.shoveled = false
            if(user.id == street_leader.id)
              drain = Drain.find_by_gid(drain_claim.try(:gid))
              drain.cleared = false
              drain.save(validate: false)
            end
            # drain.need_help = false
            message = I18n.t('messages.drain_dirty')

          elsif (need_help_keywords.include? drain_status)
            change_locale(need_help_keywords, drain_status)
            if(user.id == street_leader.id)
              need_help = {
                        'help_needed': "",
                        'need_help_category_id': 1,
                        'user_id': user.id,
                        'gid': drain_claim.try(:gid)
                    }
                @need_help = NeedHelp.new(need_help)
                if @need_help.save
                   drain.need_help = true
                end
            end

           
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

  def change_locale(keywords, status)
    if (status == keywords[0] or status == keywords[1])
      I18n.locale = 'sw'
    else
      I18n.locale = 'en'
    end
  end
  		

end
