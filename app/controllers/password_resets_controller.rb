class PasswordResetsController < ApplicationController
	before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]


  def new
  	@logo, @title, @description, @javascriptsArray = preRender('reset_pwd_new')
  end

  def create
  	@logo, @title, @description, @javascriptsArray = preRender('reset_pwd_new')
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to root_url, notice: "Email sent with password reset instructions"
    else
      @notice = "Email address not found"
      render 'new'
    end
  end


  def edit
  	@logo, @title, @description, @javascriptsArray = preRender('reset_pwd_edit')
  end

  def update
  	@logo, @title, @description, @javascriptsArray = preRender('reset_pwd_edit')
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      redirect_to @user, notice: "Password has been reset."
    else
      render 'edit'
    end
  end

  private

  	def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? && @user.authenticated_reset?( params[:id]))
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        redirect_to new_password_reset_url, notice: "Password reset has expired."
      end
    end
end
