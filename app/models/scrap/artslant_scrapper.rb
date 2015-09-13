class ArtslantScrapper < AbstractScrapper
	attr_accessor :artslanturl, :pagecount, :dateTomorrow
	ARTSLANT_SOURCE = 'artslant'

	def initialize
		puts "Artslant Scrap Start"
		super		#call absract scrapper class
		#for some reason artslant needs the tomorrow date to get "todays" openings (dum)
		@dateTomorrow = @time.month.to_s + "/" + (@time.day.to_i + 1).to_s  + "/" + @time.year.to_s
		@artslanturl = "http://www.artslant.com/ny/events/list?featured=all&fromdate=#{@dateTomorrow}&listtype=openings&todate=#{@dateTomorrow}"
		@pagecount = 1
	end

	#has pagination
	def scrap
		loop do 
			page = "&page=" + @pagecount.to_s
			html = pullHtml(@artslanturl + page)
			events = html.css("tbody#thelist tr.t1")

			break if events.empty?
			@pagecount += 1

			events.each do |e|
				imglink =  e.css("span.imagethumbfield img")[0]["src"]
				tableright = e.css("td table tr td")[1]
				date = @time.to_date.to_s + " " + e.css("td table tr td")[2].css("b span").text.split("-")[0]
				enddate = @time.to_date.to_s + e.css("td table tr td")[2].css("b span").text.split("-")[1]

				link = "http://www.artslant.com" + ( tableright.css("a")[1].nil? ? tableright.css("a")[0]["href"] : tableright.css("a")[1]["href"] )
				name = tableright.css("a span.artist").text.split.join(" ") + ": " + tableright.css("a i").text.split.join(" ")
				
				rightarray = tableright.text.split(/\n/).reject(&:empty?).reject(&:blank?)
				address =  rightarray[3] + " " + rightarray[4]
				lat, long = calculateGeo(address)
				
				org = rightarray[1]

				EventResult.create!( 
					name: name[0..98].gsub(/\s\w+\s*$/,'...'), 
					price: "0", 
					lat: lat, 
					long: long, 
					address: address, 
					imageurl: imglink , 
					eventurl: link , 
					startdate: date, 
					enddate: enddate, 
					description: "", 
					types: "art, art gallery openings", 
					source: ARTSLANT_SOURCE
				)
			end
		end
		puts "Artslant Done"
	end

end