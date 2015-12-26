class AlertMailer < ApplicationMailer
	default to: "gvoll333@gmail.com"

	def send_error_email(x, source)
		@source = source
		mail( :subject => 'Yo, Goob, fix ' + source + ' scrapper')
	end
end
