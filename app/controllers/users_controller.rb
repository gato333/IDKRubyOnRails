 class UsersController < ApplicationController
  include ApplicationHelper 
  include SessionsHelper
  require 'will_paginate/array'
	before_action :set_user, only: [:show, :edit, :edit_photo, :change_password, 
    :new_password, :change_password, :update, :destroy, :events]
  before_action :only_current_user_n_admin, only: [:edit, :update, 
    :events, :edit_photo, ]
	before_action :only_admin, only: [:destroy, :index]

  def index 
  	@logo, @title, @description, @javascriptsArray = preRender('user_index')
    @users = User.paginate(page: params[:page])
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

  def new_password
    @logo, @description, @javascriptsArray = preRender('user_password')
    @title = "EDIT USER " + @user.id.to_s + " PWD"
  end

  def change_password
    @logo, @description, @javascriptsArray = preRender('user_password')
    @title = "EDIT USER " + @user.id.to_s + " PWD"

    respond_to do |format|
      @user = validate_password_params(@user, params)
      if @user.errors.any? 
        format.html { render :new_password }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      else 
        if @user.update_attributes(user_params(params))
          format.html { redirect_to @user, notice: 'Your password was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else 
          format.html { render :new_password }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
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

  def favorite 
    event = EventResult.find(params[:id])
    @userEvent = UserEvent.new( event_id: event.id, user_id: current_user.id )
    if @userEvent.save
      render :json => { 
        :msg => 'Event ' + params[:id] + ' was successfully favorited.', 
        :status => 200
      }
    else 
      render :json => { 
        :msg => 'Event ' + params[:id] + ' was unsuccessfully favorited.',
        :status => 400
      }
    end
  end


  def unfavorite
    event = EventResult.find_by_id(params[:id])
    @userEvent = UserEvent.find_by( event_id: event.id, user_id: current_user.id )
    if(@userEvent)
      @userEvent.destroy
      render :json => {
              :msg => 'Event ' + params[:id] + ' was successfully unfavorited.', 
              :status => 200 
      }
    else 
      render :json => {
              :msg => 'Event ' + params[:id] + ' was unsuccessfully unfavorited.', 
              :status => 200 
      }
    end
  end

  def events 
    @logo, @title, @description, @javascriptsArray = preRender('user_events')
    @user_events = user_events
    #needs to be users since pagiantion is dum
    @events = EventResult.find(@user_events).paginate(page: params[:page] )
  end

  private 

  	def only_admin
      redirect_to access_denied_path if !is_admin
  	end

    def only_current_user_n_admin 
      redirect_to access_denied_path if !is_current_user(@user) && !is_admin
    end

  	def set_user
      @user = User.find_by_id(params[:id])
      if !@user 
        redirect_to unknown_path
      end
    end

    def validate_password_params(user, p)
      if p[:user][:old_password].empty?
        user.errors.add(:old_password, "can't be empty")
      elsif user.authenticate(p[:user][:old_password]) === false
        user.errors.add( :old_password, 'is the wrong current password. Please try again.')
      end
      if p[:user][:password].empty?
        user.errors.add(:password, "can't be empty")
      end
      if p[:user][:password_confirmation].empty?
        user.errors.add(:password_confirmation, "can't be empty")
      end
      if p[:user][:password] != p[:user][:password_confirmation]
        user.errors.add(:password_confirmation, "and password don't match")
      end
      if p[:user][:old_password] == p[:user][:password]
        user.errors.add(:password, "and old password can't be the same")
      end
      user
    end

	  def user_params(p)
      if( p["commit"] === "Change Photo")
        p.require(:user).permit( :picture )
      elsif( p["commit"] === "Save Description")
        p.require(:user).permit( :description )
      elsif( p["commit"] === "Change Password")
        p.require(:user).permit( :password, :password_confirmation )
      else 
        p.require(:user).permit(:name, :email, :password, :password_confirmation, 
          :user_type )
      end
    end

end
