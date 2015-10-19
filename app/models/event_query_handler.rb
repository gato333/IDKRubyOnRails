class EventQueryHandler
		require 'open-uri'
    require 'event_result'
    require "result_container"

		attr_accessor :lat, :eastlat, :westlat, :long, :northlong, :southlong, :radius, :keyword, :price

    def initialize(lat, long, radius, price, keyword = "")
    	@lat = lat.to_f
    	@long = long.to_f
    	@radius = radius.to_f
    	@price = price.to_f

      @northlat, @eastlong, @southlat, @westlong = boundingBox
  
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

    def queryDB 
      puts Time.now()
      EventResult.where("price >= ? AND price <= ? AND lat <= ? AND lat >= ? AND long >= ? AND long <= ? AND (types LIKE ? OR name LIKE ? OR address LIKE ? OR description LIKE ? )", 0.0, @price, @northlat, @southlat, @westlong, @eastlong, queryLikeHelper(@keyword), queryLikeHelper(@keyword), queryLikeHelper(@keyword), queryLikeHelper(@keyword) )
    end

    def queryLikeHelper(word)
      '%' + word + '%'
    end

   	def getEventResults
      formatResults( queryDB )
    end

    def formatResults(results)
      if !results.empty?
        resultArray = Array.new
        results.each do |r|
          rholder = ResultContainer.new
          rholder.lat = r.lat
          rholder.long = r.long
          rholder.name = r.name
          rholder.imageurl = r.imageurl
          rholder.types = r.types
          rholder.address = r.address
          rholder.price = r.price
          rholder.eventurl = r.eventurl
          rholder.startdate = r.startdate
          rholder.enddate = r.enddate
          rholder.description = r.description
          resultArray.push(rholder)
        end
        chooseRandom3(resultArray)
      else 
        "No Results"
      end
    end

    def chooseRandom3(resultArray)
      finalResults = Array.new
      until finalResults.length >= 3 || resultArray.empty? do 
        randomChoice = Random.rand(resultArray.length) 
        finalResults.push(resultArray[randomChoice])
        resultArray.delete_at(randomChoice)
      end
      finalResults
    end
end