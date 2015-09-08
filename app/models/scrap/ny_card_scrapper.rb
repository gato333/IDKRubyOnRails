class NyCardScrapper > AbstractScrapper
	attr_accessor :artcardsurl
	ARTCARDS_SOURCE = "artcards"

	def initilize
		super		#call absract scrapper class
		#for some reason artslant needs the tomorrow date to get "todays" openings (dum)
		@artcardsurl = "http://artcards.cc/"
	end

	def scrap
		html = Nokogiri::HTML(open(@artcardsurl))

		container = html.css("section")[1]
		events = container.css("article")

		events.each do |e|
			name = e.css("span[itemprop='name']").text.split.join(" ")
			imglink = e.css("a.thumb img")[0]["src"]
			link = e.css("a.thumb")[0]["href"]
			org = e.css("div[itemprop='location'] a[itemprop='url'] span").text.split.join(" ")

			address =  e.css("div[itemprop='location'] a.map-link").text.split.join(" ")
			geo = Geocoder.coordinates(address)
			lat = geo.nil? ? "" : geo[0]
			long = geo.nil? ? "" : geo[1]

			datecontainer = e.css("div[itemprop='location'] time").text.split("-")
			startdate =  @time.to_date.to_s + " " + DateTime.parse(datecontainer[0] + "pm").strftime("%H:%M")
			enddate =  @time.to_date.to_s + " " + DateTime.parse(datecontainer[1]).strftime("%H:%M")

			EventResult.create!( name: name[0..98].gsub(/\s\w+\s*$/,'...'), price: "free", lat: lat, long: long, address: address, imageurl: imglink , eventurl: link , startdate: startdate, enddate: enddate, description: "", types: "art, art gallery openings", source: ARTCARDS_SOURCE)
		end
	end

end
