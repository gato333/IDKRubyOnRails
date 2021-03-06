class EventResultsController < ApplicationController
  before_action :set_event_result, only: [:show, :edit, :update, :destroy]
  before_action :is_member_n_activated, only: [ :new, :edit, :update, :destroy ]
  before_action :only_admin, only: [:index, :count, :all]
  before_action :admin_or_current_user, only: [:edit, :update, :destroy]
  include ApplicationHelper 
  include EventResultsHelper
  include SessionsHelper
  require 'will_paginate/array'

  DEFAULT_DESCRIPTION = ApplicationHelper::DESCRIPTION 

  def index
    @logo, @title, @description, @javascriptsArray = preRender('event_index')
    @event_results = EventResult.order(startdate: :desc).paginate(page: params[:page])

    respond_to do |format|
      format.html
      format.json  { render :json => @event_results }
    end
  end

  def show
    @logo = @event_result.imageurl
    @description = @event_result.description.nil? ? DEFAULT_DESCRIPTION : @event_result.description[0..80]
    @title = "SHOW " + @event_result.id.to_s
    @javascriptsArray = preRender('event_show')
    @user_events = get_fav_events(current_user)

    respond_to do |format|
      format.html
      format.json  { render :json => @event_result }
    end
  end

  def new
    @logo, @title, @description, @javascriptsArray = preRender('event_new')
    @event_result = EventResult.new
  end

  def edit
    @javascriptsArray = preRender('event_edit')
    @title = "EDIT " + @event_result.id.to_s 
    @logo = @event_result.imageurl
    @description = @event_result.name
  end

  def count
    @logo, @title, @description, @javascriptsArray = preRender('event_count')
    query = EventQueryHandler.new
    @resultsAll = query.totalEvents
    @resultsValid = query.totalEventsHaventHappened
    
    results = { all: @resultsAll, valid: @resultsValid }
    respond_to do |format|
      format.html
      format.json  { render :json => results }
    end
  end

  def all 
    @logo, @title, @description, @javascriptsArray = preRender('event_all')
    query = EventQueryHandler.new
    @event_results = query.getAllEvents.paginate(page: params[:page])
    @user_events = get_fav_events(current_user)

    respond_to do |format|
      format.html
      format.json  { render :json => @results }
    end
  end

  def create
    @logo, @title, @description, @javascriptsArray = preRender('event_new')
    @event_result = EventResult.new( event_result_params(params) )
    respond_to do |format|
      if user_has_can_make_event(current_user.id)
        if @event_result.save
          format.html { redirect_to @event_result, notice: 'Event result was successfully created.' }
          format.json { render :show, status: :created, location: @event_result }
        else
          format.html { render :new }
          format.json { render json: @event_result.errors, status: :unprocessable_entity }
        end
      else 
        format.html { redirect_to current_user, notice: 'I\'m sorry, but you have reached your 5 event limit for event creation today.'  }
        format.json { render json: @event_result.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @javascriptsArray = preRender('event_edit') 
    respond_to do |format|
      if @event_result.update_attributes(event_result_params(params))
        format.html { redirect_to @event_result, notice: 'Event result was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_result }
      else
        format.html { render :edit }
        format.json { render json: @event_result.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @logo, @title, @description, @javascriptsArray = preRender('event_index') 
    @event_result.destroy
    respond_to do |format|
      format.html { redirect_to event_results_url, notice: 'Event result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def analytics
    @logo, @title, @description, @javascriptsArray = preRender('event_analytics')
    @results = generateEventDateData
  end

  private

  def only_admin
    redirect_to access_denied_path if !is_admin
  end

  def is_member_n_activated 
    if !logged_in?
      redirect_to( login_path, notice: "You must be logged in to access this feature.") 
    elsif !activated_member?   
      redirect_to( current_user , notice: "You must be activate your account to access this feature.")
    end 
  end

  def admin_or_current_user 
     redirect_to access_denied_path if !current_user_n_admin_id(@event_result.creator_id)
  end

  def set_event_result
    @event_result = EventResult.find_by_id(params[:id])
    if !@event_result 
      redirect_to unknown_path
    end
  end

  def event_result_params(p)
    lat, long = generateLocation(p["event_result"][:address])
    eventObj = { 
      "name" => p["event_result"][:name], 
      "lat" => lat, 
      "long" => long, 
      "address" => p["event_result"][:address], 
      "eventurl" => p["event_result"][:eventurl], 
      "imageurl" => p["event_result"][:imageurl], 
      "startdate" => createDateTime(p[:start1], p[:start2]), 
      "enddate" => createDateTime(p[:end1], p[:end2]), 
      "source" => p["event_result"][:source], 
      "types" => p["event_result"][:types], 
      "price" => p["event_result"][:price], 
      "description" => p["event_result"][:description]
    }
    if !p["event_result"][:creator_id].nil?
      eventObj["creator_id"] = p["event_result"][:creator_id]
    end 
    if !p["event_result"][:creator_name].nil?
      eventObj["creator_name"] = p["event_result"][:creator_name]
    end 
    eventObj
  end
end
