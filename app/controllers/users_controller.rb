class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update, :destroy]
	#before_action :must_be_admin, [:destroy, :index]
	include ApplicationHelper 


	LOGO = ApplicationHelper::LOGO
  DESCRIPTION = ApplicationHelper::DESCRIPTION
  DEFAULT_STATUS = ApplicationHelper::DEFAULT_STATUS


  def index 
  	@logo = LOGO
    @description = DESCRIPTION
    @title = "USER INDEX"
    @javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS ); 
    @users = User.all
	end 
  
  def new
  	@title = "NEW USER"
  	@logo = LOGO
    @description = DESCRIPTION
    @javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS );
    @user = User.new 
  end

  def show
  	@title = "SHOW USER " + @user.id.to_s 
  	@logo = LOGO
    @description = DESCRIPTION
    @javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS );
  end

  def edit 
  	@title = "EDIT USER " + @user.id.to_s 
  	@logo = LOGO
    @description = DESCRIPTION
    @javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS );
  end

  def create
    @javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS );  
    @user = User.new( user_params(params) )

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS ); 
    respond_to do |format|
      @user = User.find(params[:id]); 
      if @user.update_attributes(user_params(params))
        format.html { redirect_to @user, notice: 'User result was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS ); 
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private 

  	def must_be_admin
      redirect_to :new if !@user.admin?
  	end

  	def set_user
      @user = User.find(params[:id])
    end

	  def user_params(p)
      p.require(:user).permit(:name, :email, :password, :userType,
                                 :password_confirmation, :picture )
    end

end
