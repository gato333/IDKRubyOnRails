class SoftScraper < AbstractScrapper
	require 'open-uri'
  require 'event_result'

  attr_accessor :time, :eventcount

  def initialize
    Geocoder.configure(:lookup   => :google, :timeout => 5)
    @time = Time.now
    @eventcount = 0
  end

  def db_logger 
  end

  #abstract funciton to implement
  def scrap
  end

  def pullHtml(url)
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
