class EventQueryHandler
		require 'open-uri'
    require 'event_result'

		attr_accessor :lat, :eastlat, :westlat, :long, :northlong, :southlong, :radius, :keyword, :price, :curTime

    def initialize(queryObj=nil)
      if queryObj
      	@lat = queryObj[0] ? queryObj[0].to_f : nil
      	@long = queryObj[1] ? queryObj[1].to_f : nil
      	@radius = queryObj[2] ? queryObj[2].to_f : nil
      	@price = queryObj[3] ? queryObj[3].to_f : nil
        @keyword = queryObj[4].to_s || ""

        if( @lat.nil? || @long.nil? || @radius.nil? )
           @northlat = @eastlong = @southlat = @westlong = nil
        else 
          @northlat, @eastlong, @southlat, @westlong = boundingBox
        end 
      else 
        @lat = @long = @radius = @price = @keyword = @northlat = @eastlong  = @southlat = @westlong = @keyword = nil
      end
      @curTime = (Time.now.utc + Time.zone_offset('EST') - (60  * 60 * 2)).to_formatted_s(:db)
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
      #event that start in the furture or 2hrs ago
      EventResult.where("startdate >= ? AND price >= ? AND price <= ? AND lat <= ? AND lat >= ? AND long >= ? AND long <= ? AND (types LIKE ? OR name LIKE ? OR address LIKE ? OR description LIKE ? OR source LIKE ? )", @curTime, 0.0, @price, @northlat, @southlat, @westlong, @eastlong, queryLikeHelper(@keyword), queryLikeHelper(@keyword), queryLikeHelper(@keyword), queryLikeHelper(@keyword), queryLikeHelper(@keyword) )
    end

    def queryLikeHelper(word)
      '%' + word + '%'
    end

   	def getEventResults
      formatResults( queryDB )
    end

    def formatResults(results)
      if !results.empty?
        chooseRandom3(results.to_a)
      else 
        "ZERO_RESULTS"
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

    def totalEvents
      EventResult.count
    end

    def totalEventsHaventHappened
      #event that start in the furture or 2hrs ago
      EventResult.where("startdate >= ?", @curTime ).count
    end

    def getAllEvents
      all = EventResult.all 

      if !all.empty?
        all.to_a
      else
        "ZERO_RESULTS"
      end
    end

end