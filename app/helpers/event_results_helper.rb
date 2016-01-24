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
end
