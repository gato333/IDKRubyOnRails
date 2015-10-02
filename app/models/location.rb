class Location
	require 'net/http'
  BASE_URL = 'http://freegeoip.net/json'

    def self.getCoor(ip)
    	resp = Net::HTTP.get( URI( BASE_URL + "/" + ip) )
    	JSON.parse(resp)
    end

end