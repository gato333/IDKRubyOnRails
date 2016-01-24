class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
	require "restaurant_query_handler"
  include SessionsHelper
  include ApplicationHelper

	#page functions
  def home
    @logo, @title, @description, @javascriptsArray = preRender('home')
  end

  def do
    @logo, @title, @description, @javascriptsArray = preRender('do')
    @ip = remote_ip
    if params.include?('error') 
      @error_msg, @radius_error, @price_error = formErrorMsg(params, DO_STATUS);
    end
  end

  def eat 
    @logo, @title, @description, @javascriptsArray = preRender('eat')
    @ip = remote_ip
    if params.include?('error') 
      @error_msg, @radius_error, @price_error = formErrorMsg(params, EAT_STATUS);
    end
  end

  def random
    @logo, @title, @description, @javascriptsArray = preRender('random')
  end

  def results 
    @logo, @description, @javascriptsArray = preRender('result')
		if params["source"] == EAT_STATUS
			if validateForm(params, EAT_STATUS)
				query = RestaurantQueryHandler.new( app_params(params) )
        @results = query.getRestaurantResults
			else 
				redirect_to :action => 'eat', 
        :radius => params["radius"] || "", 
        :price => params["price"] || "", 
        :keyword => params["keyword"] || "",  
        :error => "1", 
        :lat => params["lat"] || "", 
        :long => params["long"] || ""
			end
		elsif params["source"] == DO_STATUS
			if validateForm(params, DO_STATUS)
        @googleKey = Rails.application.secrets.google_api_key; 
        query = EventQueryHandler.new( app_params(params) )
        @results = query.getEventResults
			else 
				redirect_to :action => 'do',
        :radius => params["radius"] || "", 
        :price => params["price"] || "", 
        :keyword => params["keyword"] || "",  
        :error => "1", 
        :lat => params["lat"] || "", 
        :long => params["long"] || ""
			end
		else 
			redirect_to :action => 'error', :error_msg => "Submitted from a not accepted page."
		end
    @title = params["source"]
  end

  def error 
    @logo, @title, @description, @javascriptsArray = preRender('error')
  	if params.include?(:error_msg)
  		@error_msg = params[:error_msg]
  	else 
  		@error_msg = "SOMETHING HAPPENED, dont really know what"
  	end
  end

  def access_denied 
    @logo, @title, @description, @javascriptsArray = preRender('access_denied')
  end

  def unknown
    @logo, @title, @description, @javascriptsArray = preRender('unknown')
  end


  private 
  ## helper functions 
  def app_logger 
    @@app_logger ||= Logger.new("#{Rails.root}/log/app.log")
  end

  def remote_ip
    app_logger.info(request.remote_ip)
  	if request.remote_ip == '127.0.0.1' ||  request.remote_ip == '::1'
      '108.27.76.225'
    else
      request.remote_ip
    end
  end

  def app_params(p)
    return p["lat"], p["long"], p["radius"], p["price"], p["keyword"]
  end

end
