class RestaurantQueryHandler
	require 'open-uri'
	attr_accessor :lat, :long, :radius, :price, :keyword, :url, :api
	@@lat = 0; 
	@@long = 0; 
	@@radius = 0; 
	@@price = 0; 
	@@keyword = nil; 
	@@url = "";
  api = "AIzaSyDQLyJR4lAPS7JdQ_gTBbBlntGbfS_1V3A"
	
    def initialize(lat, long, radius, price, keyword = "")
    	@lat = lat
    	@long = long 
    	@radius = radius
    	@price = price 
    	@keyword = keyword
    end

    def generateGoogleRequest
    	@url = "https://maps.googleapis.com/maps/api/place/nearbysearch/xml?location="				
    	@url.concat(@lat + "," +@long)
    	@url.concat("&radius=" + @radius)
    	@url.concat("&key=" + api )
    	@url.concat("&opennow&types=food&maxprice=" + @price)
    	if(@keyword != "")
    		@url.concat("&keyword=" + @keyword)
    	end
    end

    def getXML 
    	generateGoogleRequest
    	results = Nokogiri::XML(open(@url))
    end

    def getRestaurantResults
    	getXML
    end
end