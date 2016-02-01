class SessionsController < ApplicationController
	include ApplicationHelper 
	include SessionsHelper

  def new
    @logo, @title, @description, @javascriptsArray = preRender('session_new') 
	end

  def create
    @logo, @title, @description, @javascriptsArray = preRender('session_new') 

    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user, notice: (user.activated? ? "Welcome back, " + user.name : "Account not activated. Check your email " + 
        "for the activation link.")
    else
      @notice = "Invalid email/password combination"
      @email = params[:session][:email]
      render 'new'
    end
  end

  def destroy
  	log_out
  	redirect_to login_path
  end
end