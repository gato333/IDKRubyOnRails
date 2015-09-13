class EventbriteScrapper < AbstractScrapper
	attr_accessor :pagecount, :urlbeg, :urlend
	EVENTBRITE_SOURCE = 'eventbrite'

	def initialize
		puts "Eventbrite Scrap Start"
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

			events = html.css(".js-event-list-container.l-block-stack div.l-block-2")
			break if events.empty?
			@pagecount += 1

			events.each do |e|
				link =  e.css("a.js-search-result-click-action")[0]["href"]
				imglink = e.css(".list-card__header img")[0]["src"]
				price = e.css(".list-card__header span.list-card__label").text.split("-").first
				price = freeTest(price)
				name = e.css(".list-card__body .list-card__title").text.split.join(" ")
				date = e.css(".list-card__body .list-card__date").text.split.join(" ")
				address = e.css(".list-card__body .list-card__venue").text.split.join(" ")
				org = e.css(".list-card__body .list-card__organizer").text.split.join(" ")
				
				geo = e.css(".list-card__body .list-card__venue span[itemprop='geo']")
				lat = geo.css("meta[itemprop='latitude']")[0]["content"]
				long = geo.css("meta[itemprop='longitude']")[0]["content"]

				EventResult.create!( 
					name: name[0..97].gsub(/\s\w+\s*$/,'...'), 
					price: price, 
					lat: lat, 
					long: long, 
					address: address, 
					imageurl: imglink.nil? ? '' : imglink, 
					eventurl: link, 
					startdate: date, 
					enddate: "", 
					description: '', 
					types: '', 
					source: EVENTBRITE_SOURCE
				)
			end
		end
		puts "Eventbrite Done"
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