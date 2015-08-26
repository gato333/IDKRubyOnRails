module PagesHelper

	EAT_STATUS = "EAT"
	DO_STATUS = "DO"

	def self.validateForm(params)
		if params["radius"] == nil || params["radius"] == ""
			return false 
		elsif params["price"] == nil || params["price"] == ""
			return false
		else 
			return true
		end
	end
	
end
