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
			containers = html.css("#leftpart ul.longsmartlist")

			containers.each do |c|
				events = c.css(" > li")

				events.each do |e|
					name = e.css("h4 a").text.split.join(" ")
					imglink = "http://www.nyartbeat.com/" + e.css(".smartpic_m a img")[0]["src"]
					link = e.css(".smartpic_m a")[0]["href"]

					addressholder =  e.css("div.smart_details ul li")[2]
					address = addressholder.css("span").text
					lat, long = calculateGeo(address)

					datecontainer = e.css("div.smart_details ul li")[4]

					timeSelect = datecontainer.text.scan( /\d{2}\:\d{2}/ )
					dateSelect = datecontainer.text.scan( /\d{4}\-\d{2}\-\d{2}/ )

					startdate = dateSelect[0] + " " + timeSelect[0]
					enddate = timeSelect[1].nil? ? startdate : dateSelect[0] + " " + timeSelect[1]

					orgcontainer = e.css("div.smart_details ul li")[0]
					org = orgcontainer.text.split.join(" ")[3..-1]

					description = deepscrap(link);

					createEvent( name, address, 0, lat, long, 
						imglink, link, startdate, enddate, description, 
						"art, art gallery openings", NYARTBEAT_SOURCE )

					@eventcount += 1
				end
			end

			message = "Art Beat Done"
			endScrapOutput( message, @eventcount.to_s )
		rescue Exception => e  
			failHandler(e, NYARTBEAT_SOURCE)
		ensure 
			return @eventcount
		end 
	end


	def deepscrap(link)
		html = pullHtml(link)
		description = StringHelper::strip_tags(html.css(".intro_event").to_s)
		description.gsub!('&#13;', ' ') 
	end

end