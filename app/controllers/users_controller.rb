 class UsersController < ApplicationController
  include ApplicationHelper 
  include SessionsHelper
	before_action :set_user, only: [:show, :edit, :edit_photo, :update, :destroy, :events]
  before_action :only_current_user_n_admin, only: [:edit, :update, :events, :edit_photo, ]
	before_action :only_admin, only: [:destroy, :index]

  def index 
  	@logo, @title, @description, @javascriptsArray = preRender('user_index')
    @users = User.all
	end 
  
  def new
    @logo, @title, @description, @javascriptsArray = preRender('user_new')
    @user = User.new 
  end

  def show
    @title = "SHOW USER " + @user.id.to_s 
    @logo, @description, @javascriptsArray = preRender('user_show')
  end

  def edit 
    @logo, @description, @javascriptsArray = preRender('user_edit')
  	@title = "EDIT USER " + @user.id.to_s 
  end

  def edit_photo
    @logo, @description, @javascriptsArray = preRender('user_photo')
    @title = "EDIT USER " + @user.id.to_s + " PHOTO"
  end

  def create 
    @logo, @title, @description, @javascriptsArray = preRender('user_new')
    @user = User.new( user_params(params) )

    respond_to do |format|
      if @user.save
        log_in @user
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @logo, @description, @javascriptsArray = preRender('user_edit')
    @title = "EDIT USER " + @user.id.to_s 

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
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def events 
    @logo, @title, @description, @javascriptsArray = preRender('user_events')
   # will bring up favorited events
  end

  private 

  	def only_admin
      redirect_to access_denied_path if !is_admin
  	end

    def only_current_user_n_admin 
      redirect_to access_denied_path if !is_current_user(@user) && !is_admin
    end

  	def set_user
      @user = User.find(params[:id])
    end

	  def user_params(p)
      p.require(:user).permit(:name, :email, :description, :password, :user_type,
                                 :password_confirmation, :picture )
    end

end
