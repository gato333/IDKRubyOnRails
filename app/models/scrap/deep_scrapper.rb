class DeepScrapper < AbstractScrapper
	require 'open-uri'
	require 'event_result'

  attr_accessor :time, :eventcount

	def initialize
    @eventcount = 0
  end

  def db_logger 
  end

  #abstract funciton to implement
  def heavyScrap
  end

  def pullHtml(url)
  end
  
end
