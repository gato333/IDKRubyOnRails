class EventQueryHandler
		require 'open-uri'
    require 'event_result'

		attr_accessor :lat, :eastlat, :westlat, :long, :northlong, :southlong, :radius, :keyword, :price

    def initialize(lat, long, radius, price, keyword = "")
    	@lat = lat.to_f
    	@long = long.to_f
    	@radius = radius.to_f
    	@price = price.to_f
      @eastlat, @northlong = new_coords( 45 )
      @westlat, @southlong = new_coords( 225 )
    	@keyword = keyword.to_s
      puts @lat.to_s + " " + @long.to_s + " " + @radius.to_s + " " + @price.to_s + " " + @keyword.to_s
      puts @eastlat.to_s + " " + @westlat.to_s + " " + @southlong.to_s + " " + @northlong.to_s
    end

    def new_coords(bearing)
      r = 3959;
      #  New latitude in degrees.
      new_latitude = rad2deg(Math.asin(Math.sin(deg2rad(@lat)) * Math.cos(@radius / r) + Math.cos(deg2rad(@lat)) * Math.sin(@radius / r) * Math.cos(deg2rad(bearing)) ));
      # New longitude in degrees.
      new_longitude = rad2deg(deg2rad(@long) + Math.atan2(Math.sin(deg2rad(bearing)) * Math.sin(@radius / r) * Math.cos(deg2rad(@lat)), Math.cos(@radius / r) - Math.sin(deg2rad(@lat)) * Math.sin(deg2rad(new_latitude)) ));

      return new_latitude, new_longitude;
    end

    def deg2rad(deg)
      deg * Math::PI / 180
    end

    def rad2deg(rad)
      rad / 180 * Math::PI 
    end

   	def getEventResults
      ja8
      EventResult.find_by_price_and_lat_and_long(0..@price+1, @westlat..@eastlat, @southlong..@northlong)
   	end
end