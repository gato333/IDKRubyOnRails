class ArtslantScrapper < AbstractScrapper
	attr_accessor :artslanturl, :pagecount, :dateTomorrow
	ARTSLANT_SOURCE = 'artslant'

	def initialize
		message = "Artslant Scrap Start"
		super(message)		#call absract scrapper class
		#for some reason artslant needs the tomorrow date to get "todays" openings (dum)
		@dateTomorrow = @time.month.to_s + "/" + (@time.day.to_i + 1).to_s  + "/" + @time.year.to_s
		@artslanturl = "https://www.artslant.com/ny/events/list?featured=all&fromdate=#{@dateTomorrow}&listtype=openings&todate=#{@dateTomorrow}"
		@pagecount = 1
	end

	#has pagination
	def scrap
		begin
			loop do 
				page = "&page=" + @pagecount.to_s
				html = pullHtml(@artslanturl + page)
				events = html.css("div#innerlist .list-item")
				break if events.empty?
				@pagecount += 1

				events.each do |e|
					imglink =  e.css(".thumb-span img")[0]["src"]
					link = "https://www.artslant.com" + e.css(".thumb-span a")[0]["href"]
					name = e.css(".name-span .event span").text + ": " + e.css(".name-span .event i").text

					startdate = @time.to_date.to_s + " " + e.css(".address-span b span")[0].text.split("-")[0]
					enddate = @time.to_date.to_s +  e.css(".address-span b span")[0].text.split("-")[1]

					address = e.css(".address-span").to_s.split("<br>")
					address =  explodeImplode( address[1] + address[2] )
					lat, long = calculateGeo(address)

					description = deepscrap(link)

					createEvent(name, address, 0, lat, long, imglink, 
						link, startdate, enddate, description, 
						"art, art gallery openings", ARTSLANT_SOURCE )

					@eventcount += 1
				end
			end
			message = "Artslant Done"
			endScrapOutput( message, @eventcount.to_s )
		rescue Exception => e  
			failHandler(e, ARTSLANT_SOURCE)
		ensure 
			return @eventcount
		end
	end

	def deepscrap(link)
		html = pullHtml(link)
		description = StringHelper::strip_tags(html.css(".description").to_s)
		description.gsub!('&#13;', ' ') 
	end

end