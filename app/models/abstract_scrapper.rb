class AbstractScrapper
	require 'open-uri'

  attr_accessor :time

	def initialize
		Geocoder.configure(:lookup   => :dstk)
    @time = Time.now
  end

  #abstract funciton to implement
  def scrap
  end
  
end
