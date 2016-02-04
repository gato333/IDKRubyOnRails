module EventResultsHelper
	def generateLocation(address)
    geo = Geocoder.coordinates(address)
    lat = geo.nil? ? "" : geo[0]
    long = geo.nil? ? "" : geo[1]
    return lat, long
  end 

  def createDateTime(start1, start2)
   start1[0] + " " + start2["(4i)"] + ":" + start2["(5i)"] + ":00"
  end

  def user_has_can_make_event(user_id)
  	yesterday = DateTime.now() - 1 
  	userEvents = EventResult.where(" creator_id = ? AND created_at > ? ", user_id, yesterday ).count
    if(userEvents < 5)
    	return true
    end 
    return false 
  end

  def generateEventDateData
    # 4am-11am  11am-5pm  5pm-12am
    results = [
      ['Time', 'Morning', 'Afternoon', 'Evening']
    ]; 
    dateInfoObj = {}
    EventResult.all.each do |e|
      day = e.startdate.strftime("%Y-%m-%d")
      daykey = e.startdate.strftime("%a, %d %b %y")
      puts daykey
      if !dateInfoObj.has_key?(daykey) 
        dateInfoObj[daykey] = { "Morning" => 0, "Afternoon" => 0, "Evening" => 0 }
      end
      timeDay = getKey(e.startdate, day)
      dateInfoObj[daykey][timeDay] = dateInfoObj[daykey][timeDay] + 1
    end
    dateInfoObj.each do |key, timeArr|
      results.push( [key, timeArr["Morning"], timeArr["Afternoon"], timeArr["Evening"]])
    end
    results.to_json
  end

  def getKey( eventdate, day )
    key = 'Morning'
    if( eventdate < DateTime.parse(day + ' 18:00:00') && eventdate >= DateTime.parse(day + ' 11:00:00') )
      key = "Afternoon"
    elsif( eventdate >= DateTime.parse(day + ' 18:00:00') )
      key = "Evening"
    end
    key
  end

end
