class PagesController < ApplicationController
	require "location.rb"
	protect_from_forgery

	EAT_STATUS = "EAT"
	DO_STATUS = "DO"

  def home
  end

  def do
  	location = Location.new 
  	location = Location.getCoor
  	@latitude = location.latitude
  	@longitude = location.longitude
  end

  def eat
  	location = Location.new 
  	location = Location.getCoor
  	@latitude = location.latitude
  	@longitude = location.longitude
  end

  def random
  end

  def results 
  	if params.include?("source")
  		@title = params["source"]
  		if @title == EAT_STATUS


  		elsif @title == DO_STATUS


  		else 
  			redirect_to :action => 'error', :error_msg => "Submitted from a not accepted page."
  		end
  	else 
  		redirect_to :action => 'error', :error_msg => "You must submit from either the EAT or DO pages to get Results. You can't just jump to the end!"
  	end
  end

  def error 
  	if params.include?(:error_msg)
  		@error_msg = params[:error_msg]
  	else 
  		@error_msg = "SOMETHING HAPPENED, dont really know what"
  	end
  end

end
