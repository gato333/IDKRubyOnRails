module ApplicationHelper

	EAT_STATUS = "EAT"
	DO_STATUS = "DO"

	def self.validateForm( params , status )
		if !validateRadius(params["radius"])
			return false 
		elsif !validatePriceEat(params["price"], status)
			return false
		elsif !validatePriceDo(params["price"], status)
			return false
		else 
			return true
		end
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

	def self.validatePriceDo( price, status )
		if price == nil || price == "" && status == DO_STATUS
			return false
		end
		return true
	end

	def self.formErrorMsg( params, status )
		error_msg = ""
		radius_error = price_error = nil
		if !validateRadius(params["radius"])
			radius_error = true
			error_msg += "You must supply a valid RADIUS to be able to generate a response. "
		end
		if !validatePriceEat(params["price"], status)
			price_error = true
			error_msg += "You must supply a valid PRICE to be able to generate a response. "
		elsif !validatePriceDo(params["price"], status)
			price_error = true
			error_msg += "You must supply a valid PRICE to be able to generate a response. "
		end
		return error_msg, radius_error, price_error
	end
	
end
