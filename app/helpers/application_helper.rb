module ApplicationHelper

	EAT_STATUS = "EAT"
	DO_STATUS = "DO"
	DEFAULT_STATUS = "DEFAULT"
	RANDOM_STATUS = "RANDOM"
	RESULT_STATUS = "RESULT"
	SHOW_STATUS = "SHOW"
	EDIT_STATUS = "EDIT"

	def self.validateForm( params , status )
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

	def self.validateGeoLocation( params )
		puts params
		if params["lat"] == nil || params["lat"] == "" || params["long"] == nil || params["long"] == ""
			return false 
		end 
		return true
	end

	def self.validateRadius( radius )
		if radius == nil || radius == "" || radius == 0 || radius == "0"
			return false 
		end 
		return true
	end

	def self.validatePriceEat( price, status )
		if price == nil || price == "0" && status == EAT_STATUS
			return false
		end
		return true
	end

	def self.formErrorMsg( params, status )
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

	def self.includeJavascripts(status) 
		if status == SHOW_STATUS
			['application', 'show', 'googleMaps']
		elsif status == EDIT_STATUS
			['application', 'edit']
		elsif status == EAT_STATUS || status == DO_STATUS
			['application', 'form']
		elsif status == RANDOM_STATUS
			['application', 'random']
		elsif status == RESULT_STATUS
			['application', 'result', 'googleMaps']
		elsif status == DEFAULT_STATUS
			['application']
		else
			"problem assinging javacripts to page" 
		end
	end

end
