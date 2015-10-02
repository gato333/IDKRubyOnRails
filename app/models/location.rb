class Location
	require 'net/http'
  base_uri 'http://freegeoip.net/json'

    def self.getCoor(ip)
    	resp = Net::HTTP.get( "/" + ip)
    	JSON.parse(resp.body)
    end

end