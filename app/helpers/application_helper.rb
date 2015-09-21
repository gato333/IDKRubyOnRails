module ApplicationHelper

	EAT_STATUS = "EAT"
	DO_STATUS = "DO"

	def self.validateForm(params , status)
		if params["radius"] == nil || params["radius"] == "" || params["radius"] == 0 || params["radius"] == "0"
			return false 
		elsif params["price"] == nil || params["price"] == "" && status == DO_STATUS
			return false
		elsif params["price"] == nil || params["price"] == "0" && status == EAT_STATUS
			return false
		else 
			return true
		end
	end
	
end
