class PagesController < ApplicationController
	protect_from_forgery

	require "location.rb"
	require "restaurant_query_handler.rb"
	include ApplicationHelper  

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
  		if @title == ApplicationHelper.EAT_STATUS
  			if ApplicationHelper.validateForm(params)
  				query = RestaurantQueryHandler.new( params["lat"], params["long"], params["radius"], params["price"], params["keyword"])
  				@results = query.getRestaurantResults
  			else 
  				redirect_to :action => 'eat', :radius => params["radius"] || "", :price => params["price"] || "", :keyword => params["keyword"] || "", :error => "1"
  			end
  		elsif @title == ApplicationHelper.DO_STATUS
  			if ApplicationHelper.validateForm(params)
  				@results = "hi"
  			else 
					redirect_to :action => 'do', :radius => params["radius"] || "", :price => params["price"] || "", :keyword => params["keyword"] || "", :error => "1"
  			end
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
