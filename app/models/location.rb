class Location
	include HTTParty
  base_uri 'http://freegeoip.net/json'

    def self.getCoor(ip)
    	resp = self.get( "/" + ip)
    	JSON.parse(resp.body)
    end

end