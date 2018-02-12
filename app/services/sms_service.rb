class SmsService
  def initialize()
  	@account_sid = ENV['SMS_ACCOUNT_SID']
	  @auth_token = ENV['SMS_AUTH_TOKEN']
    @from_number = ENV['SMS_FROM_PHONE_NUMBER']
	  @client = Twilio::REST::Client.new @account_sid, @auth_token
  end


  # Send sms to the specified number
  def send_sms(content, tonumber)
    tonumber = format(tonumber);

  	begin
      @client.messages.create({
  	  :from => @from_number,
  	  :to => tonumber,
  	  :body => content,
      })
    rescue Twilio::REST::RequestError => e
      message =  I18n.t("errors.sms_not_sent")
    else
      message = I18n.t("notice.success")
    end

    return message

  end

  
  # Loop over messages and print out a property for each one
  def new_sms_updates(content, tonumber)
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

  # Create the required response after updates in the model
  # Params: user User, drain_status Array or String
  # returns: String

  def generate_message(user, drain_status)
    message = ''
    clean_keywords = ['msafi', 'Msafi', 'clean', 'Clean'].map(&:downcase)
    dirt_keywords = ['mchafu', 'Mchafu', 'dirty', 'Dirty',
       'not clean', 'Not clean'].map(&:downcase)
    need_help_keywords = ['msaada','Msaada', 'need help', 'Need help'].map(&:downcase)
    street_leader = User.joins(:roles).where(roles: {id: 2})
                        .find_by_street_id(user.street_id)

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

        if (clean_keywords.include? drain_status)
          change_locale(clean_keywords, drain_status)
          if (drain_claim)
            drain_claim.shoveled = true
          end
          drain = Drain.find_by_gid(drain_id)
          if(updates_authentication(user, drain))
            drain.cleared = true
            drain.save(validate: false)
            message = I18n.t('messages.drain_cleaned')
          else
            if (drain_claim)
              if (drain_claim.save(validate: false))
                message = I18n.t('messages.thanks')
              else
                message = I18n.t('messages.error')
              end
            else
              message = I18n.t('messages.drain_unknown')
            end
          end
          # drain.need_help = false

        elsif (dirt_keywords.include? drain_status)
          change_locale(dirt_keywords, drain_status)
          if (drain_claim)
            drain_claim.shoveled = false
          end

          drain = Drain.find_by_gid(drain_id)
          if(updates_authentication(user, drain))
            drain.cleared = false
            drain.save(validate: false)
            message = I18n.t('messages.drain_dirty')
          else
             if (drain_claim)
              if (drain_claim.save(validate: false))
                message = I18n.t('messages.thanks')
              else
                message = I18n.t('messages.error')
              end
            else
              message = I18n.t('messages.drain_unknown')
            end
          end
        else
          message = I18n.t('messages.unknown')
        end


        if (need_help_keywords.include? drain_status)
          change_locale(need_help_keywords, drain_status)
          
          # drain_claim.shoveled = false
          # drain.need_help = true
          drain = Drain.find_by_gid(drain_id)
          puts updates_authentication(user, drain);
          if(updates_authentication(user, drain))
            need_help = {
                      'help_needed': '',
                      'need_help_category_id': 4,
                      'user_id': user.id,
                      'gid': drain.id
            }
            @need_help = NeedHelp.new(need_help)
            if (@need_help.save(validate: true))
              drain.need_help = true
              drain.save(validate: false)
              message = I18n.t('messages.need_help_thanks')
            else
              message = I18n.t('messages.need_help_error')
            end
          else
            message = I18n.t('messages.need_help_user_error')
          end
          
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

  # def updates_authentication(user, drain)
  #   if user.present? && drain.present?
  #     if user.has_role(2)
  #       if drain.has_street(user.try(:street_id))
  #         return true
  #       end
  #     end
  #   end
  #   return false
  # end
end
