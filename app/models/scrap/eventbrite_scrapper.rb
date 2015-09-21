class EventbriteScrapper < AbstractScrapper
	attr_accessor :pagecount, :urlbeg, :urlend
	EVENTBRITE_SOURCE = 'eventbrite'

	def initialize
		db_logger.info( "Eventbrite Scrap Start")
		super		#call absract scrapper class
		@pagecount = 1
		@urlbeg = "https://www.eventbrite.com/d/ny--manhattan/events--today/?"
		@urlend = "&slat=40.7831&slng=-73.9712&sort=best"
	end
	#has pagination
	def scrap
		loop do 
			page = "page=" + @pagecount.to_s
			url = @urlbeg + page + @urlend
			html = pullHtml(url)

			events = html.css("section.js-content div.g-cell div.poster-card.js-d-poster")
			break if events.empty?
			@pagecount += 1

			events.each do |e|
				linkholder =  e.css("a.js-event-link.js-xd-track-link")
				link = linkholder[0]["href"]
				imglink = linkholder.css(".poster-card__header .poster-card__image img")[0]["src"]
				price = linkholder.css(".poster-card__header .poster-card__label").text.split("-").first
				price = freeTest(price)
				name = explodeImplode(linkholder.css(".poster-card__body .poster-card__title"))
				date = explodeImplode(linkholder.css(".poster-card__body .poster-card__date"))
				address = explodeImplode(linkholder.css(".poster-card__body .poster-card__venue"))
				typelist = e.css(".poster-card__footer .poster-card__tags a")
				type = ""
				typelist.each do |t|
					type.concat(explodeImplode(t).gsub("#", "") + " ")
				end

				geo = e.css(".poster-card__body .poster-card__venue span[itemprop='location'] span[itemprop='geo']")
				lat = geo.css("meta[itemprop='latitude']")[0]["content"]
				long = geo.css("meta[itemprop='longitude']")[0]["content"]

				@eventcount += 1
				EventResult.create!( 
					name: name, 
					price: price, 
					lat: lat, 
					long: long, 
					address: address, 
					imageurl: imglink.nil? ? '' : imglink, 
					eventurl: link, 
					startdate: date, 
					enddate: '', 
					description: '', 
					types: type, 
					source: EVENTBRITE_SOURCE
				)
			end
		end
		db_logger.info( @eventcount.to_s + " events created")
		db_logger.info( "Eventbrite Done")
	end

	def freeTest(price)
		if price.nil?
			return "n/a"
		end
		price = price.gsub("$", "")
    if price.downcase == "free"
      "0"
    else 
      price
    end
  end
end