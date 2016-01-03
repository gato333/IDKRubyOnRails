class ArtBeatScrapper < AbstractScrapper 
	attr_accessor :nyartbeaturl
	NYARTBEAT_SOURCE = "nyartbeat"

	def initialize
		message = "Art Beat Scrap Start"
		super(message)		#call absract scrapper class
		@nyartbeaturl = "http://www.nyartbeat.com/list/event_opening"
	end

	#no pagination
	def scrap
		begin
			html = pullHtml(@nyartbeaturl)
			events = html.css("ul.events_list li")
			
			events.each do |e|
				name = e.css("h4 a").text.split.join(" ")
				imglink = "http://www.nyartbeat.com/" + e.css("div.smartpic_m a img")[0]["src"]
				link = e.css("div.smartpic_m a")[0]["href"]

				addressholder =  e.css("div.smart_details ul li")[2]
				address = addressholder.css("span").text
				lat, long = calculateGeo(address)
				
				datecontainer = e.css("div.smart_details ul li")[4]
				date = datecontainer.text.scan( /\d{2}\:\d{2}/ )
				startdate = @time.to_date.to_s + " " + date[0]
				enddate = date[1].nil? ? "" : @time.to_date.to_s + " " + date[1]

				orgcontainer = e.css("div.smart_details ul li")[0]
				org = orgcontainer.text.split.join(" ")[3..-1]

				description = deepscrap(link);

				createEvent( name, address, "0", lat, long, 
					imglink, link, startdate, enddate, description, 
					"art, art gallery openings", NYARTBEAT_SOURCE )
				
				@eventcount += 1
			end
			message = "Art Beat Done"
			endScrapOutput( message, @eventcount.to_s )
		rescue Exception => e  
			puts e.inspect
			puts e
			AlertMailer.send_error_email(NYARTBEAT_SOURCE).deliver_now
		end
	end


	def deepscrap(link)
		html = pullHtml(link)
		description = StringHelper::strip_tags(html.css(".intro_event").to_s)
		description.gsub!('&#13;', ' ') 
	end

end