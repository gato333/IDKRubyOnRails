class AlertMailer < ApplicationMailer
	default to: ENV["default_email"]

	def send_error_email(source)
		@source = source
		mail( :subject => 'Yo, Goob, fix ' + source + ' scrapper')
	end

end
