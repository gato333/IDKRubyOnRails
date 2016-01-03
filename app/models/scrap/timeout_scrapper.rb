class TimeoutScrapper < AbstractScrapper 
	attr_accessor :timouturl
	TIMEOUT_SOURCE = "timeout"

	def initialize
		message = "Timeout Scrap Start"
		super(message)		#call absract scrapper class
		@basetimeouturl = "http://www.timeout.com"
		@timeoutsurl = @basetimeouturl + "/newyork/things-to-do/things-to-do-in-new-york-today"
	end

	#no pagination
	def scrap
		begin
			html = pullHtml(@timeoutsurl)
			events = html.css("#tab__panel_1 .small_list .tiles article")

			events.each do |e|
				container =  e.css(".feature-item__content .row")

				leftcontainer = container.css(".feature-item__column")[0]
				rightcontainer = container.css(".feature-item__column")[1]
				
				name = rightcontainer.css("h3").text

				link = @basetimeouturl + leftcontainer.css("a")[0]["href"]
				imglink = leftcontainer.css("img")[0]["src"]

				description = rightcontainer.css("p").text			

				lat, long, address, startdate, enddate, price, types = deepscrap(link)
				
				createEvent(name, address, price, lat, long, 
					imglink, link, startdate, enddate, 
					description, types, TIMEOUT_SOURCE )

				@eventcount += 1 
			end

			message = "Timeout Done"
			endScrapOutput( message, @eventcount.to_s )
		rescue
			AlertMailer.send_error_email(TIMEOUT_SOURCE).deliver_now
		end
	end


	def deepscrap(link)
		html = pullHtml(link)

		typecontainer= html.css(".page_tags .page_tag")
		types = ""
		typecontainer.each do |t|
			types += explodeImplode(t).downcase
		end

		addresscontainer = html.css("#tab___content_2 .listing_details tbody tr")[1]
		
		address = addresscontainer.nil? ? "" : addresscontainer.css("td")
		lat, long = calculateGeo(address)

		todayinstance = html.css("#tab___content_3 .occurrences__occurrence_day")[0]

		startdate = ( todayinstance.nil? || todayinstance.css(".occurrence__time").nil? ) ? "" : @time.to_date.to_s + " " + findAddTimeSufix(explodeImplode(todayinstance.css(".occurrence__time"))) 
		enddate = ""

		if todayinstance.nil? || todayinstance.css(".occurrence__price").empty?
			price = "0"
		elsif todayinstance.css(".occurrence__price") =~ /\d/  
			price = cleanMoney(todayinstance.css(".occurrence__price").split("-")[0])
		else 
			price = todayinstance.css(".occurrence__price")
		end

		return lat, long, address, startdate, enddate, price, types
	end

end