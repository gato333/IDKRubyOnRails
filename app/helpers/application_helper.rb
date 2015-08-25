module ApplicationHelper

	EAT_STATUS = "EAT"
	DO_STATUS = "DO"

	def validateForm(params)
		if params["radius"] == nill || params["radius"] == ""
			return false 
		elsif params["price"] == nill || params["price"] == ""
			return false
		else 
			return true
		end
	end

end
