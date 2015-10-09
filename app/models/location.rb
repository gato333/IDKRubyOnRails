class Location
	require 'resolv-replace'
  BASE_URL = 'http://freegeoip.net/json'

    def self.getCoor(ip)
    	response = Typhoeus.get(BASE_URL + "/" + ip)
			JSON.parse(response.response_body)
    end
end