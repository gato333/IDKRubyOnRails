class AccountActivationsController < ApplicationController
	 def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated_activation?( params[:id])
      user.activate
      log_in user
      redirect_to user, notice: "Account activated!"
    else
      redirect_to root_url, notice: "Invalid activation link"
    end
  end
end
