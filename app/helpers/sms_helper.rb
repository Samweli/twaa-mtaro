module SmsHelper
	account_sid = 'AC12f20bfa2f6630b53c40266939dab38e'
	auth_token = 'c2e4f138358a300f07031c7026c9341f' 

	@client = Twilio::REST::Client.new account_sid, auth_token 

  def sendsms(content,tonumber)
    	 
	# set up a client to talk to the Twilio REST API 
	 
	@client.account.messages.create({
	  :from => '+14256540807', 
	  :to => tonumber, 
	  :body => 'Karibu', 
	})
  end

  def new_sms_updates(content,tonumber)
	# Loop over messages and print out a property for each one
	@client.account.messages.list.each do |message|
	puts message.body
	end
  end

end