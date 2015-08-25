class Location
	require 'geoplugin'

    def self.getCoor
       location = Geoplugin.me
    end

end