class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include SessionsHelper
  include ApplicationHelper

  def about
    @logo, @title, @description, @javascriptsArray = preRender('about')
  end

  def search
    @logo, @title, @description, @javascriptsArray = preRender('search')
    @ip = remote_ip
    if params.include?('error') 
      @error_msg, @radius_error, @price_error = formErrorMsg(params, SEARCH_STATUS);
    end
  end

  def random
    @logo, @title, @description, @javascriptsArray = preRender('random')
  end

  def results
    if params["mapview"].nil?
      @logo, @description, @javascriptsArray = preRender('result')
    else
      redirect_to :action => 'map_results',
        :radius => params["radius"] || "", 
        :price => params["price"] || "", 
        :keyword => params["keyword"] || "",  
        :error => "1", 
        :lat => params["lat"] || "", 
        :long => params["long"] || "",
        :source => SEARCH_STATUS
    end
		if params["source"] == SEARCH_STATUS
			if validateForm(params, SEARCH_STATUS)

        query = EventQueryHandler.new( app_params(params) )
        @results = query.getEventResults
        @user_events = get_fav_events(current_user)
			else 
				redirect_to :action => 'search',
          :radius => params["radius"] || "", 
          :price => params["price"] || "", 
          :keyword => params["keyword"] || "",  
          :error => "1", 
          :lat => params["lat"] || "", 
          :long => params["long"] || ""
			end
		else 
			redirect_to :action => 'search'
		end
    @title = params["source"]
  end

  def map_results 
    @logo, @description, @javascriptsArray = preRender('map_result')
    if params["source"] == SEARCH_STATUS
      if validateForm(params, SEARCH_STATUS)
        query = EventQueryHandler.new( app_params(params) )
        @results = query.getEventResults
        @user_events = get_fav_events(current_user)
      else 
        redirect_to :action => 'search',
        :radius => params["radius"] || "", 
        :price => params["price"] || "", 
        :keyword => params["keyword"] || "",  
        :error => "1", 
        :lat => params["lat"] || "", 
        :long => params["long"] || ""
      end
    else 
      redirect_to :action => 'search'
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