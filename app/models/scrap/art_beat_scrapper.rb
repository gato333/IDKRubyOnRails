class ArtBeatScrapper < AbstractScrapper 
	attr_accessor :nyartbeaturl
	NYARTBEAT_SOURCE = "nyartbeat"

	def initilize
		super		#call absract scrapper class
		#for some reason artslant needs the tomorrow date to get "todays" openings (dum)
		@nyartbeaturl = "http://www.nyartbeat.com/list/event_opening"
	end

	def scrap
		html = Nokogiri::HTML(open(@nyartbeaturl))
		container = html.css("ul.longsmartlist")[0]
		events = container.css("> li")

		events.each do |e|
			name = e.css("h4 a").text.split.join(" ")
			imglink = "http://www.nyartbeat.com/" + e.css("div.smartpic_m a img")[0]["src"]
			link = e.css("div.smartpic_m a")[0]["href"]

			addressholder =  e.css("div.smart_details ul li")[2]
			address = addressholder.css("span").text

			datecontainer = e.css("div.smart_details ul li")[4]
			date = datecontainer.text.scan( /\d{2}\:\d{2}/ )
			startdate = @time.to_date.to_s + " " + date[0]
			enddate = @time.to_date.to_s + " " + date[1]

			geo = Geocoder.coordinates(address)
			lat = geo.nil? ? "" : geo[0]
			long = geo.nil? ? "" : geo[1]

			orgcontainer = e.css("div.smart_details ul li")[0]
			org = orgcontainer.text.split.join(" ")[3..-1]

			EventResult.create!( name: name[0..98].gsub(/\s\w+\s*$/,'...'), price: "free", lat: lat, long: long, address: address, imageurl: imglink , eventurl: link , startdate: startdate, enddate: enddate, description: "", types: "art, art gallery openings", source: NYARTBEAT_SOURCE)
		end
	end

end
