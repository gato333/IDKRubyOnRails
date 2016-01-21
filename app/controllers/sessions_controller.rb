class SessionsController < ApplicationController
	include ApplicationHelper 
	include SessionsHelper

	LOGO = ApplicationHelper::LOGO
  DESCRIPTION = ApplicationHelper::DESCRIPTION
  DEFAULT_STATUS = ApplicationHelper::DEFAULT_STATUS

  def new
  	@logo = LOGO
    @description = DESCRIPTION
    @title = "Log In"
    @javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS ); 
	end

  def create
  	@logo = LOGO
    @description = DESCRIPTION
    @title = "Log In"
  	@javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS ); 

    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
    	log_in user
      redirect_to user, notice: "Welcome back, " + user.name
    else
    	@notice = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  	log_out
  	redirect_to login_path
  end
end