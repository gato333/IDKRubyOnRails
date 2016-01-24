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
end
