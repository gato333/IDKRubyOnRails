class ArtBeatScrapper < AbstractScrapper 
	attr_accessor :nyartbeaturl
	NYARTBEAT_SOURCE = "nyartbeat"

	def initialize
		db_logger.info("Art Beat Scrap Start")
		super		#call absract scrapper class
		@nyartbeaturl = "http://www.nyartbeat.com/list/event_opening"
	end

	#no pagination
	def scrap
		html = pullHtml(@nyartbeaturl)
		container = html.css("ul.longsmartlist")[0]
		events = container.css("> li")

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

			@eventcount += 1 
			EventResult.create!( 
				name: name, 
				price: "0", 
				lat: lat, 
				long: long, 
				address: address, 
				imageurl: imglink, 
				eventurl: link , 
				startdate: startdate, 
				enddate: enddate, 
				description: description, 
				types: "art, art gallery openings", 
				source: NYARTBEAT_SOURCE
			)
		end
		db_logger.info( @eventcount.to_s + " events created" )
		db_logger.info( "Art Beat Done" )
	end


	def deepscrap(link)
		html = pullHtml(link)
		html.css(".intro_event").to_s.strip_tags
	end

end