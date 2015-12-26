class MyFreeConcertScrapper < AbstractScrapper 
	attr_accessor :myfreeconcertsurl
	MYFREECONCERT_SOURCE = "myfreeconcerts"

	def initialize
		message = "My Free Concerts Scrap Start"
		super(message)		#call absract scrapper class
		@basefreeconcerturl = "http://myfreeconcert.com"
		@myfreeconcertsurl = @basefreeconcerturl + "/nyc/calendar/" + @time.year.to_s + "/" + @time.month.to_s + "/" + @time.day.to_s
	end

	#no pagination
	def scrap
		puts @myfreeconcertsurl
		html = pullHtml(@myfreeconcertsurl)
		events = html.css(".month-calendar-current-day .item-list li")

		events.each do |e|
			name = e.css("a span.item-list-info .item-list-title").text
			imglink = e.css(".item-list-img img")[0]["src"]
			link = @basefreeconcerturl + e.css("a.item-list-item")[0]["href"]

			startdate = @time.to_date.to_s + " " + findAddTimeSufix(e.css("a .item-list-date").text.split("-")[0])
			enddate = @time.to_date.to_s + findAddTimeSufix(e.css("a .item-list-date").text.split("-")[1])

			description, lat, long, address = deepscrap(link)

			createEvent( name, address, "0", lat, long, imglink, 
				link, startdate, enddate, description, 
				"music, concert, sound, art", MYFREECONCERT_SOURCE )
			
			@eventcount += 1 
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