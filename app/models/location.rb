class Location
	require 'net/http'

    def self.getCoor(ip)
      url = 'http://freegeoip.net/json/' + ip
			resp = Net::HTTP.get_response(URI.parse(url))
			resp_text =  JSON.parse(resp.body)
    end

end