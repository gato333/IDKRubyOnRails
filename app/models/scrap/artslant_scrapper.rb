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
				events = html.css("tbody#thelist tr.t1")

				break if events.empty?
				@pagecount += 1

				events.each do |e|
					imglink =  e.css("span.imagethumbfield img")[0]["src"]
					tableright = e.css("td table tr td")[1]
					startdate = @time.to_date.to_s + " " + e.css("td table tr td")[2].css("b span").text.split("-")[0]
					enddate = @time.to_date.to_s + e.css("td table tr td")[2].css("b span").text.split("-")[1]
					# GET THE RIGHT LINK 
					artslantlink =  "http://www.artslant.com" + tableright.css("b a")[0]["href"] 
					link = tableright.css("a")[1].nil? ? (tableright.css("a")[0].nil? ? "http://www.artslant.com" + tableright.css("b a")[0]["href"]  : tableright.css("a")[0]["href"] ) : tableright.css("a")[1]["href"] 
					name = tableright.css("a span.artist").text.split.join(" ") + ": " + tableright.css("a i").text.split.join(" ")
					
					rightarray = tableright.text.split(/\n/).reject(&:empty?).reject(&:blank?)
					if( rightarray[3].nil? || rightarray[4].nil? )
						address = ""
					else 
						address =  rightarray[3] + " " + rightarray[4]
					end
					lat, long = calculateGeo(address)
					
					org = rightarray[1]
					
					description = deepscrap(artslantlink)
			
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