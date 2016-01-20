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
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
    	log_in user
      redirect_to user
    else
    	flash[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  end

end
