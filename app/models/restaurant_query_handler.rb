class RestaurantQueryHandler
	require 'open-uri'
	require 'json'
	require "result_container"

    attr_accessor :lat, :long, :radius, :keyword, :price, :url
    API = "AIzaSyDQLyJR4lAPS7JdQ_gTBbBlntGbfS_1V3A"
	
    def initialize(lat, long, radius, price, keyword = "")
    	@lat = lat.to_s
    	@long = long.to_s 
    	@radius = radius.to_s
    	@price = price.to_s
    	@keyword = keyword
    end

    def generateGoogleRequest 
    	@url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="				
    	@url.concat( @lat + "," + @long )
    	@url.concat("&radius=" + @radius)
    	@url.concat("&key=" + API )
    	@url.concat("&opennow&types=food&maxprice=" + @price)
    	if(@keyword != "")
    		@url.concat("&keyword=" + @keyword)
    	end
    end

    def getJSON
    	generateGoogleRequest
    	results = JSON.load(open(@url))
    end

    def generateGoogleImage( photoref )
    	imageurl = "https://maps.googleapis.com/maps/api/place/photo?"
    	imageurl.concat("key=" + API)
    	imageurl.concat("&photoreference=" + photoref)
    	imageurl.concat("&maxheight=150")
    end

    def json2Object
    	results = getJSON
    	if results["status"] == "OK"
    		resultArray = Array.new
    		results["results"].each do |r|
    			rholder = ResultContainer.new
    			rholder.lat = r["geometry"]["location"]["lat"]
    			rholder.long = r["geometry"]["location"]["lng"]
    			rholder.name = r["name"]
    			rholder.imageurl = r.include?("photos") ? generateGoogleImage( r["photos"][0]["photo_reference"] ) : r["icon"]
    			rholder.types = r["types"].join(", ")
    			rholder.address = r["vicinity"]
    			rholder.price = moneyConversion(r["price_level"])
    			rholder.rating = r["rating"].nil? || !r["rating"] ? "no rating" : r["rating"]
    			resultArray.push(rholder)
    		end
    		chooseRandom3(resultArray)
    	else 
    		results["status"]
    	end
    end

    def moneyConversion(money)
        if money == 1
            return "$"
        elsif money == 2
            return "$$"
        elsif money == 3
            return "$$$"
        elsif money == 4
            return "$$$$"
        else 
            return ""
        end
    end

    def chooseRandom3(resultArray)
    	finalResults = Array.new
    	until finalResults.length >= 3 do 
    		randomChoice = Random.rand(resultArray.length) 
    		finalResults.push(resultArray[randomChoice])
    		resultArray.delete_at(randomChoice)
    	end
    	finalResults
    end

    def getRestaurantResults
    	json2Object
    end
end