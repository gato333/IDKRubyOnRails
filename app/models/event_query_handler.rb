class EventQueryHandler
		require 'open-uri'
		require "result_container"

		attr_accessor :lat, :long, :radius, :keyword, :price
		URL = "www."

    def initialize(lat, long, radius, price, keyword = "")
    	@lat = lat.to_s
    	@long = long.to_s 
    	@radius = radius.to_s
    	@price = price.to_s
    	@keyword = keyword.to_s
    end

   	def getEventResults

   	end
end