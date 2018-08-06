module ApplicationHelper

	LOGO = "http://49.media.tumblr.com/c8bdf16535f80091a941843de701532b/tumblr_n9stfetbYf1r5mmhlo1_400.gif"
  DESCRIPTION = "Secret Events NYC"

	DO_STATUS = "DO"
	DEFAULT_STATUS = "DEFAULT"
	RANDOM_STATUS = "RANDOM"
	MAP_RESULT_STATUS = "MAP_RESULT"
	RESULT_STATUS = "RESULT"
	SHOW_STATUS = "SHOW"
	EDIT_STATUS = "EDIT"
	COUNT_STATUS = "COUNT"
	USER_EVENT_STATUS = "USER_EVENT"
	USER_EDIT_STATUS = "USER_EDIT"
	ANALYTICS_STATUS = "ANALYTICS"

	USER_DESCRIPTION_STATUS = "USER_DESCRIPT"

	def validateForm( params , status )
		if !validateGeoLocation(params)
			return false 
		elsif !validateRadius(params["radius"])
			return false 
		elsif !validatePriceEat(params["price"], status)
			return false
		else 
			return true
		end
	end

	def validateGeoLocation( params )
		if params["lat"] == nil || params["lat"] == "" || params["long"] == nil || params["long"] == ""
			return false 
		end 
		return true
	end

	def validateRadius( radius )
		if radius == nil || radius == "" || radius == 0 || radius == "0"
			return false 
		end 
		return true
	end

	def validatePriceEat( price, status )
		return true
	end

	def formErrorMsg( params, status )
		error_msg = ""
		radius_error = price_error = nil
		if !validateGeoLocation(params)
			error_msg += "There was a problem discerning where your location was, please try submiting again. <br>"
		end
		if !validateRadius(params["radius"])
			radius_error = true
			error_msg += "You must supply a valid RADIUS to be able to generate a response. <br>"
		end
		if !validatePriceEat(params["price"], status)
			price_error = true
			error_msg += "You must supply a valid PRICE to be able to generate a response. <br>"
		end
		return error_msg, radius_error, price_error
	end

	def includeJavascripts(status) 
		if status == SHOW_STATUS
			['application', 'show', 'googleMaps', 'social']
		elsif status == COUNT_STATUS
			['application', 'count']
		elsif status == EDIT_STATUS
			['application', 'edit']
		elsif status == DO_STATUS
			['application', 'form']
		elsif status == RANDOM_STATUS
			['application', 'random']
		elsif status == RESULT_STATUS
			['application', 'result', 'googleMaps', 'social']
		elsif status == MAP_RESULT_STATUS
			['application', 'map_result', 'googleMaps', 'social']
		elsif status == USER_EDIT_STATUS
			['application', 'edit_user']
		elsif status == USER_EVENT_STATUS
			['application', 'result', 'googleMaps', 'social', 'user_event']
		elsif status == USER_DESCRIPTION_STATUS
			['application', 'description' ]
		elsif status == ANALYTICS_STATUS
			['application', 'googleCharts']
		else 
			['application']
		end
	end

	def preRender(page)
		if page === 'home'
    	return LOGO, "HOME", DESCRIPTION, includeJavascripts(DEFAULT_STATUS)
		elsif page === 'do'
    	return LOGO, "DO", DESCRIPTION, includeJavascripts(DO_STATUS)
		elsif page === 'random'
			return LOGO, "RANDOM", "Uncertainty Helper", includeJavascripts(RANDOM_STATUS)
		elsif page === 'result'
			return LOGO, DESCRIPTION, includeJavascripts(RESULT_STATUS)
		elsif page === 'map_result'
			return LOGO, DESCRIPTION, includeJavascripts(MAP_RESULT_STATUS)
		elsif page ===  'error'
			return LOGO, "ERROR", "Problems in Paradise", includeJavascripts(DEFAULT_STATUS)
  	elsif page === 'unknown'
  		return LOGO, "UNKWOWN", "UNKWOWN", includeJavascripts(DEFAULT_STATUS)
  	elsif page === "access_denied"
  		return LOGO, "ACCESS DENIED", "ACCESS DENIED", includeJavascripts(DEFAULT_STATUS)
  	
  	elsif page === 'event_index'
  		return LOGO, DESCRIPTION, "INDEX", includeJavascripts(DEFAULT_STATUS)
  	elsif page === 'event_new'
  		return LOGO, "Create New", "NEW", includeJavascripts(EDIT_STATUS)
  	elsif page === 'event_edit'
  		return includeJavascripts(EDIT_STATUS)
  	elsif page === 'event_show'
  		return includeJavascripts(SHOW_STATUS)
  	elsif page === 'event_count'
  		return LOGO, "COUNT", "Admin Panel", includeJavascripts(COUNT_STATUS)
  	elsif page === 'event_all'
  		return LOGO, "ALL", "Admin Panel", includeJavascripts(RESULT_STATUS)
  	elsif page === 'event_analytics'
  		return LOGO, "EVENT ANALYTICS", "Admin Panel", includeJavascripts(ANALYTICS_STATUS)
  	
  	elsif page === 'user_index'
  		return LOGO, DESCRIPTION, "Admin Panel", includeJavascripts(DEFAULT_STATUS)
  	elsif page === 'user_new'
    	return LOGO, DESCRIPTION, "NEW USER", includeJavascripts(USER_EDIT_STATUS)
  	elsif page === 'user_edit'
  		return LOGO, DESCRIPTION, includeJavascripts(USER_EDIT_STATUS)
  	elsif page === 'user_show'
  		return LOGO, DESCRIPTION, includeJavascripts(USER_DESCRIPTION_STATUS)
  	elsif page === 'user_photo'
  		return LOGO, DESCRIPTION, includeJavascripts(DEFAULT_STATUS)
  	elsif page === 'user_events'
    	return LOGO, DESCRIPTION, "FAV EVENTS", includeJavascripts(RESULT_STATUS)
    elsif page === 'fav_events'
    	return LOGO, DESCRIPTION, "FAV EVENTS", includeJavascripts(USER_EVENT_STATUS)
  	elsif page === 'user_password'
    	return LOGO, DESCRIPTION, includeJavascripts(DEFAULT_STATUS)

    elsif page === 'session_new'
    	return LOGO, DESCRIPTION, "Log In", includeJavascripts(DEFAULT_STATUS)
  	
  	elsif page === 'reset_pwd_new'
  		return LOGO, DESCRIPTION, "RESET PWD", includeJavascripts(DEFAULT_STATUS)
  	elsif page === 'reset_pwd_edit'
  		return LOGO, DESCRIPTION, "RESET PWD", includeJavascripts(DEFAULT_STATUS)
  	end
	end

end
