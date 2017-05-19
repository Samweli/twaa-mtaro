class SmsController < ApplicationController
	def new
		puts params

		# sidewalk = Sidewalk.find_by_user_phone_number(from_number)

		# if (sidewalk_status == 'msafi')
		# 	sidewalk.cleared = true
		# 	sidewalk.need_help = false

  #     		sidewalk.save(validate: false)	
  #     	end

		render :json => params
	end
end
