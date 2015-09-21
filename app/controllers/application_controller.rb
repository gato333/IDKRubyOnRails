class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  require "location.rb"
	require "restaurant_query_handler"
	include ApplicationHelper  

	#page functions
  def home
  end

  def do
  	location = Location.getCoor(remote_ip)
  	@latitude = location["latitude"]
  	@longitude = location["longitude"]
  end

  def eat      
  	location = Location.getCoor(remote_ip)
  	@latitude = location["latitude"]
  	@longitude = location["longitude"]
  end

  def random
  end

  def results 
  	if params.include?("source")
  		@title = params["source"]
  		if @title == ApplicationHelper::EAT_STATUS
  			if ApplicationHelper.validateForm(params, ApplicationHelper::EAT_STATUS)
  				query = RestaurantQueryHandler.new( params["lat"], params["long"], params["radius"], params["price"], params["keyword"])
          @results = query.getRestaurantResults
  			else 
  				redirect_to :action => 'eat', :radius => params["radius"] || "", :price => params["price"] || "", :keyword => params["keyword"] || "", :error => "1"
  			end
  		elsif @title == ApplicationHelper::DO_STATUS
  			if ApplicationHelper.validateForm(params, ApplicationHelper::DO_STATUS)
  				query = EventQueryHandler.new( params["lat"], params["long"], params["radius"], params["price"], params["keyword"])
          @results = query.getEventResults
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

  ## helper functions 

  def app_logger 
    @@app_logger ||= Logger.new("#{Rails.root}/log/app.log")
  end

  def remote_ip
  	 if request.remote_ip == '127.0.0.1' ||  request.remote_ip == '::1'
      '190.100.238.198'
    else
      request.remote_ip
    end
  end

end
