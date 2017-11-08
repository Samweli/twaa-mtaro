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
	  :from => '+16786195792',
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

end