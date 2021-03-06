class AbstractScrapper
	require 'open-uri'
	require 'event_result'
  require 'string_helper'

  attr_accessor :time, :eventcount

  def initialize(msg)
    @geocodio = Geocodio::Client.new
    @time = Time.now
    @eventcount = 0
    db_logger.info(msg)
    puts msg
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
    if textManipulate.nil? 
      textManipulate
    elsif textManipulate.kind_of? String  
      textManipulate.split.join(" ")
    else 
      textManipulate.text.split.join(" ")
    end
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
    results = @geocodio.geocode([address])
    lat = "", long = ""
    unless results.nil? or results.best.nil?
      lat = results.best.latitude
      long = results.best.longitude
    end
    return lat, long
  end

  def endScrapOutput(msg, count)
    db_logger.info( count + " events created")
    db_logger.info(msg)
    puts count + " events created"
    puts msg
  end

  def cleanMoney(money)
    money.gsub!('$','')
  end

  def createEvent(name, address, price, lat, long, imglink, 
    link, startdate, enddate, description, types, source)
    #address, name, and link must be not empty and not nil to create an event
    if( !(address.nil? || address === "" || name.nil? || name === "" ))
      event = EventResult.find_or_initialize_by( 
        name: explodeImplode(name), 
        startdate: DateTime.parse(startdate)
      )
      event.update_attributes(  
        price: price, 
        lat: lat, 
        long: long, 
        address: explodeImplode(address), 
        imageurl: imglink, 
        eventurl: link ,  
        enddate: enddate, 
        description: explodeImplode(description), 
        types: types, 
        source: source, 
        creator_name: "IDK", 
        creator_id: 1  
      )
      event.save
    end
  end

  def failHandler(err, source)
    puts err.message
    puts err.backtrace.join("\n")
    begin
      AlertMailer.send_error_email(err, source).deliver_now
    rescue Exception => e
      puts e.message
      puts e.backtrace.join("\n")
    end
  end

end
