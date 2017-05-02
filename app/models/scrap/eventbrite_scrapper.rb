class EventbriteScrapper < AbstractScrapper
	attr_accessor :pagecount, :urlbeg, :urlend
	EVENTBRITE_SOURCE = 'eventbrite'

	def initialize
		message = "Eventbrite Scrap Start"
		super( message )		#call absract scrapper class
		@pagecount = 1
		@urlbeglist = [
			"https://www.eventbrite.com/d/ny--manhattan/events--today/?",
			"https://www.eventbrite.com/d/ny--brooklyn/events--today/?crt=regular&slat=40.678178&slng=-73.944158&vp_ne_lat=40.7175&vp_ne_lng=-73.9043&vp_sw_lat=40.6555&vp_sw_lng=-73.9860",
		]
		@urlend = "&sort=best&view=gallery"
	end
	#has pagination
	def scrap
		begin
			@urlbeglist.each do |urlbeg|
				loop do
					page = "page=" + @pagecount.to_s
					url = urlbeg + page + @urlend
					html = pullHtml(url)

					events = html.css(".js-event-list-container > div")
					break if events.empty? || @pagecount > 4
					@pagecount += 1

					events.each do |e|
						link = e.css(".js-event-link")[0]["href"]
						imglink = e.css(".list-card__header .list-card__image img")[0]["src"]
						price = e.css(".list-card__header .list-card__label").text.split("-").first
						price = freeTest(price)
						name = e.css(".list-card__body .list-card__title")
						startdate = @time.to_date.to_s + " " + e.css(".list-card__body .list-card__date").text
						address = e.css(".list-card__body .list-card__venue").text
						typelist = e.css(".list-card__footer .list-card__tags a")
						types = ""
						typelist.each do |t|
							types.concat(explodeImplode(t).downcase.gsub("#", "") + " ")
						end

						lat, long = calculateGeo(address)
						description = deepscrap(link);

						createEvent(name, address, price, lat, long, 
							imglink.nil? ? '' : imglink, link, startdate, '', 
							description, types, EVENTBRITE_SOURCE )
						
						@eventcount += 1
					end
				end
			end
			message = "Eventbrite Done"
			endScrapOutput( message, @eventcount.to_s )
		rescue Exception => e  
			failHandler(e, EVENTBRITE_SOURCE)
		ensure
			return @eventcount
		end
	end

	def deepscrap(link)
		html = pullHtml(forceHTTPS(link))
		description = html.css('div[itemprop="description"]')
		description = StringHelper::strip_tags(description.to_s)

		forbiddenChars = { '&#13;' => '' , '&quot;'  => '', '&gt;'  => '','&amp;'=> '&' }
		forbiddenChars.each do |key , value|
			description.gsub!(key, value)
		end
		description
	end

	def forceHTTPS(link)
		if link.include? "https://"
			link
		else
			link.sub! "http://" , "https://"
		end
	end

	def freeTest(price)
		if price.nil?
			return -1
		end
		price = price.gsub("$", "")
    if price.downcase == "free"
      0
    else 
      price.to_f
    end
  end
end