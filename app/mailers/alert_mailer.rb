class AlertMailer < ApplicationMailer


	def send_error_email(err, source)
		@source = source
		@err = err 
		puts "error has occured, email is being sent."
		mail( to: ENV["endpoint_email"], 
			:subject => 'Yo, Goob, fix ' + source + ' scrapper')
	end

end
