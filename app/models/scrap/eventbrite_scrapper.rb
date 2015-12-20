class EventbriteScrapper < AbstractScrapper
	attr_accessor :pagecount, :urlbeg, :urlend
	EVENTBRITE_SOURCE = 'eventbrite'

	def initialize
		message = "Eventbrite Scrap Start"
		super( message )		#call absract scrapper class
		@pagecount = 1
		@urlbeg = "https://www.eventbrite.com/d/ny--manhattan/events--today/?"
		@urlend = "&slat=40.7831&slng=-73.9712&sort=best&view=gallery"
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

				description = deepscrap(link);

				@eventcount += 1
				EventResult.create( 
					name: name, 
					price: price, 
					lat: lat, 
					long: long, 
					address: address, 
					imageurl: imglink.nil? ? '' : imglink, 
					eventurl: link, 
					startdate: date, 
					enddate: '', 
					description: description, 
					types: type, 
					source: EVENTBRITE_SOURCE
				)
			end
		end
		message = "Eventbrite Done"
		endScrapOutput( message, @eventcount.to_s )
	end

	def deepscrap(link)
		html = pullHtml(forceHTTPS(link))
		description = StringHelper::strip_tags(html.css(".panel_section .description").to_s)
		description.gsub!('&#13;', ' ')
		description.gsub!('&amp;', '&')
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