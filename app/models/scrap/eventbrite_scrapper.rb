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
		begin
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
					name = linkholder.css(".poster-card__body .poster-card__title")
					startdate = @time.to_date.to_s + " " + linkholder.css(".poster-card__body .poster-card__date .event-time")
					address = linkholder.css(".poster-card__body .poster-card__venue")
					typelist = e.css(".poster-card__footer .poster-card__tags a")
					types = ""
					typelist.each do |t|
						types.concat(explodeImplode(t).downcase.gsub("#", "") + " ")
					end

					geo = e.css(".poster-card__body .poster-card__venue span[itemprop='location'] span[itemprop='geo']")
					lat = geo.css("meta[itemprop='latitude']")[0]["content"]
					long = geo.css("meta[itemprop='longitude']")[0]["content"]

					description = deepscrap(link);

					createEvent(name, address, price, lat, long, 
						imglink.nil? ? '' : imglink, link, startdate, '', 
						description, types, EVENTBRITE_SOURCE )
					
					@eventcount += 1
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