class NyCardScrapper < AbstractScrapper
	attr_accessor :artcardsurl
	ARTCARDS_SOURCE = "artcards"

	def initialize
		message = "NY Art Card Scrap Start"
		super(message)		#call absract scrapper class
		@artcardsurl = "http://artcards.cc/"
	end
	#no pagination
	def scrap
		begin
			html = pullHtml(@artcardsurl)
			container = html.css("section")[1]
			events = container.css("article")

			events.each do |e|
				name = e.css("span[itemprop='name']")
				imglink = e.css("a.thumb img").empty? ? "" : e.css("a.thumb img")[0]["src"]
				link = e.css("div[itemprop='location'] a[itemprop='url']")[0]["href"]
				org = e.css("div[itemprop='location'] a[itemprop='url'] span") 
				address = e.css("div[itemprop='location'] a.map-link").text.gsub(":","")
				address = address + " New York, NY"
				lat, long = calculateGeo(address)
				
				datecontainer = e.css("div[itemprop='location'] time").text.split("-")
				datecontainer = datecontainer.map { |x| x == "noon" ? "12" : x }
				if( datecontainer.length > 1 )
					startdate =  @time.to_date.to_s + " " + DateTime.parse( findAddTimeSufix( datecontainer[0] )).strftime("%H:%M")
					enddate =  @time.to_date.to_s + " " + DateTime.parse( findAddTimeSufix( datecontainer[1] )).strftime("%H:%M")
				elsif ( datecontainer[0].to_i.to_s == datecontainer[0] )
					startdate =  @time.to_date.to_s + " " + DateTime.parse( findAddTimeSufix( datecontainer[0] )).strftime("%H:%M")
					enddate =  ""
				else
					startdate =  @time.to_date.to_s 
					enddate =  @time.to_date.to_s 
				end
				# not possible to do deep scrap on this site (too bare bones)
				description = deepscrap

				createEvent(name, address, 0, lat, long, imglink, 
					link, startdate, enddate, description, 
					"art, art gallery openings", ARTCARDS_SOURCE )
				
				@eventcount += 1 
			end
			message = "NY Art Card Done"
			endScrapOutput( message, @eventcount.to_s )
		rescue Exception => e  
			failHandler(e, ARTCARDS_SOURCE)
		end
	end

	def deepscrap
		super
	end
end