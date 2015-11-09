class AbstractScrapper
	require 'open-uri'
	require 'event_result'
  require 'string'

  attr_accessor :time, :eventcount

  def initialize
    Geocoder.configure(:lookup   => :google, :timeout => 5)
    @time = Time.now
    @eventcount = 0
  end

  def db_logger 
    @@db_logger ||= Logger.new("#{Rails.root}/log/db.log")
  end

  #abstract funciton to implement
  def scrap
  end

  def deepscrap
    ""
  end

  def pullHtml(url)
  	Nokogiri::HTML(open(url))
  end

  def explodeImplode(textManipulate)
    textManipulate.text.split.join(" ")
  end

  # test to see if there is time sufix in a string 
  # if so returns it unscathed 
  # other wise adds pm to it
  def findAddTimeSufix(text)
    if text.include? "am" or text.include? "pm" or text.include? "AM" or text.include? "PM" 
      return text
    end 
    text + "pm"
  end

  def calculateGeo(address)
    geo = Geocoder.coordinates(address)
    lat = geo.nil? ? "" : geo[0]
    long = geo.nil? ? "" : geo[1]
    return lat, long
  end
end
