class EventQueryHandler
		require 'open-uri'
    require 'event_result'

		attr_accessor :lat, :eastlat, :westlat, :long, :northlong, :southlong, :radius, :keyword, :price

    def initialize(lat, long, radius, price, keyword = "")
    	@lat = lat.to_f
    	@long = long.to_f
    	@radius = radius.to_f
    	@price = price.to_f

      @northlong, @eastlat, @southlong, @westlat = boundingBox
  
    	@keyword = keyword.to_s
      puts @lat.to_s + " " + @long.to_s + " " + @radius.to_s + " " + @price.to_s + " " + @keyword.to_s
      puts @eastlat.to_s + " " + @westlat.to_s + " " + @southlong.to_s + " " + @northlong.to_s
    end

    def boundingBox
      latConFactor = @radius / 69
      longConFactor = @radius / 69 / Math.cos(deg2rad(@lat)).abs

      min_lat = @lat - latConFactor
      max_lat = @lat + latConFactor
      min_long = @long - longConFactor
      max_long  = @long + longConFactor

      if (min_lat  < -90) 
        min_lat = 90 - (-90 - min_lat )
      end
      if (max_lat  > 90) 
        max_lat = -90 + (max_lat  - 90)
      end
      if (min_long  < -180) 
        min_long = 180 - (-180 - min_long)
      end
      if (max_long > 180) 
        max_long = -180 + (max_long - 180)
      end
      return  max_lat, max_long, min_lat, min_long
    end

    def deg2rad(deg)
      deg * ( Math::PI / 180 )
    end

    def rad2deg(rad)
      rad * ( 180 / Math::PI )
    end

   	def getEventResults
      ja8
      EventResult.find_by_price_and_lat_and_long(0.0..@price+1, @westlat..@eastlat, @southlong..@northlong)
   	end
end