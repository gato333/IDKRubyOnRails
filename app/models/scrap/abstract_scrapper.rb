class AbstractScrapper
	require 'open-uri'
	require 'event_result'

  attr_accessor :time, :eventcount

	def initialize
  end

  def db_logger 
    @@db_logger ||= Logger.new("#{Rails.root}/log/db.log")
  end

  #abstract funciton to implement
  def scrap
  end

  def pullHtml(url)
  	Nokogiri::HTML(open(url))
  end
  
end
