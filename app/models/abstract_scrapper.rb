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

  def pullHtml(url)
  	Nokogiri::HTML(open(url))
  end

  def explodeImplode(textManipulate)
  	textManipulate.text.split.join(" ")
  end

  def calculateGeo(address)
  	geo = Geocoder.coordinates(address)

		lat = geo.nil? ? "" : geo[0]
		long = geo.nil? ? "" : geo[1]
		return lat, long
  end
  
end
