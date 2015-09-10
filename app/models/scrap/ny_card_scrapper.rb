require "scrap/abstract_scrapper"
class NyCardScrapper < AbstractScrapper
	attr_accessor :artcardsurl
	ARTCARDS_SOURCE = "artcards"

	def initialize
		super		#call absract scrapper class
		@artcardsurl = "http://artcards.cc/"
	end
	#no pagination
	def scrap
		html = pullHtml(@artcardsurl)
		container = html.css("section")[1]
		events = container.css("article")

		events.each do |e|
			name = explodeImplode( e.css("span[itemprop='name']"))
			imglink = e.css("a.thumb img")[0]["src"]
			link = e.css("a.thumb")[0]["href"]
			org = explodeImplode( e.css("div[itemprop='location'] a[itemprop='url'] span") )

			address =  explodeImplode( e.css("div[itemprop='location'] a.map-link") )
			lat, long = calculateGeo(address)

			datecontainer = e.css("div[itemprop='location'] time").text.split("-")
			startdate =  @time.to_date.to_s + " " + DateTime.parse(datecontainer[0] + "pm").strftime("%H:%M")
			enddate =  @time.to_date.to_s + " " + DateTime.parse(datecontainer[1]).strftime("%H:%M")

			EventResult.create!( name: name[0..98].gsub(/\s\w+\s*$/,'...'), price: "free", lat: lat, long: long, address: address, imageurl: imglink , eventurl: link , startdate: startdate, enddate: enddate, description: "", types: "art, art gallery openings", source: ARTCARDS_SOURCE)
		end
	end

end