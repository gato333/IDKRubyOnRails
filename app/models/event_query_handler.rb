class EventQueryHandler
		require 'open-uri'
    require 'event_result'
    require "result_container"

		attr_accessor :lat, :eastlat, :westlat, :long, :northlong, :southlong, :radius, :keyword, :price

    def initialize(lat = nil , long = nil, radius = nil, price = nil, keyword = "")
    	@lat = lat.nil? ? lat : lat.to_f
    	@long = long.nil? ? long : long.to_f
    	@radius = radius.nil? ? radius : radius.to_f
    	@price = price.nil? ? 0 : price.to_f

      if( @lat.nil? || @long.nil? || @radius.nil? )
         @northlat = @eastlong = @southlat = @westlong = nil
      else 
        @northlat, @eastlong, @southlat, @westlong = boundingBox
      end 

    	@keyword = keyword.to_s
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
      curTime = (Time.now() - (60  * 60 * 2)).to_formatted_s(:db)
      EventResult.where("startdate >= ? AND price >= ? AND price <= ? AND lat <= ? AND lat >= ? AND long >= ? AND long <= ? AND (types LIKE ? OR name LIKE ? OR address LIKE ? OR description LIKE ? OR source LIKE ? )", curTime, 0.0, @price, @northlat, @southlat, @westlong, @eastlong, queryLikeHelper(@keyword), queryLikeHelper(@keyword), queryLikeHelper(@keyword), queryLikeHelper(@keyword), queryLikeHelper(@keyword) )
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

        puts "Current time " + Time.now().to_formatted_s(:db) 
        results.each do |r|
          puts r.startdate
          puts r.startdate >  Time.now().to_formatted_s(:db) 
          rholder = ResultContainer.new
          rholder.lat = r.lat
          rholder.id = r.id
          rholder.long = r.long
          rholder.name = r.name
          rholder.imageurl = r.imageurl
          rholder.types = r.types
          rholder.address = r.address
          rholder.price = r.price
          rholder.eventurl = r.eventurl
          rholder.startdate = r.startdate
          rholder.enddate = r.enddate
          rholder.source = r.source
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

    def totalEvents
      EventResult.count
    end

    def totalEventsHaventHappened
      #event that start in the furture or 2hrs ago
      curTime = (Time.now() - (60  * 60 * 2)).to_formatted_s(:db)
      puts "CURRENT TIME" + curTime.to_s
      EventResult.where("startdate >= ?", curTime ).count
    end
end