class TimeoutScrapper < AbstractScrapper 
	attr_accessor :timouturl
	TIMEOUT_SOURCE = "myfreeconcerts"

	def initialize
		message = "Timeout Scrap Start"
		super(message)		#call absract scrapper class
		@basetimeouturl = "http://www.timeout.com"
		@timeoutsurl = @basefreeconcerturl + "/newyork/things-to-do/things-to-do-in-new-york-today"
	end

	#no pagination
	def scrap
		puts @timeoutsurl
		html = pullHtml(@timeoutsurl)
		events = html.css(".month-calendar-current-day .item-list li")

		events.each do |e|
			name = e.css("a span.item-list-info .item-list-title").text
			imglink = e.css(".item-list-img img")[0]["src"]
			link = @basefreeconcerturl + e.css("a.item-list-item")[0]["href"]

			startdate = @time.to_date.to_s + " " + findAddTimeSufix(e.css("a .item-list-date").text.split("-")[0])
			enddate = @time.to_date.to_s + findAddTimeSufix(e.css("a .item-list-date").text.split("-")[1])

			description, lat, long, address = deepscrap(link)

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
				types: "music, concert, sound, art", 
				source: MYFREECONCERT_SOURCE
			)
		end
		message = "My Free Concerts Done"
		endScrapOutput( message, @eventcount.to_s )
	end


	def deepscrap(link)
		html = pullHtml(link)

		description = StringHelper::strip_tags(html.css("div.event-desc-full").to_s)
		description.gsub!('&#13;', ' ') 

		venuelink = @basefreeconcerturl + html.css(".event-where .event-venue a")[0]['href']
		venuehtml = pullHtml(venuelink)

		address = venuehtml.css(".venue-address").text
		lat, long = calculateGeo(address)

		return description, lat, long, address
	end

end