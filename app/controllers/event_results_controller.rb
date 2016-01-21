class EventResultsController < ApplicationController
  before_action :set_event_result, only: [:show, :edit, :update, :destroy]
  before_action :is_member, only: [ :new ]
  before_action :only_admin, only: [:index, :edit, :update, :destroy, :count, :all]
  include ApplicationHelper 
  include SessionsHelper

  LOGO = ApplicationHelper::LOGO
  DESCRIPTION = ApplicationHelper::DESCRIPTION

  DEFAULT_STATUS = ApplicationHelper::DEFAULT_STATUS
  SHOW_STATUS = ApplicationHelper::SHOW_STATUS
  EDIT_STATUS = ApplicationHelper::EDIT_STATUS

  # GET /event_results
  # GET /event_results.json
  def index
    @logo = LOGO
    @description = DESCRIPTION
    @title = "INDEX"
    @javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS ); 
    @event_results = EventResult.all

    respond_to do |format|
      format.html
      format.json  { render :json => @event_results }
    end
  end

  # GET /event_results/1
  # GET /event_results/1.json
  def show
    @logo = @event_result.imageurl
    @description = @event_result.description[0..80]
    @title = "SHOW " + @event_result.id.to_s
    @javascriptsArray = ApplicationHelper.includeJavascripts( SHOW_STATUS ); 
    puts @event_result
    respond_to do |format|
      format.html
      format.json  { render :json => @event_result }
    end
  end

  # GET /event_results/new
  def new
    @logo = LOGO
    @description = "Create New"
    @title = "NEW"
    @javascriptsArray = ApplicationHelper.includeJavascripts( EDIT_STATUS ); 
    @event_result = EventResult.new
  end

  # GET /event_results/1/edit
  def edit
    @title = "EDIT " + @event_result.id.to_s 
    @logo = @event_result.imageurl
    @description = @event_result.name
    puts @event_result
    @javascriptsArray = ApplicationHelper.includeJavascripts( EDIT_STATUS ); 
  end

  def count
    @logo = LOGO
    @title = "COUNT"
    @description = "Hidden Page"
    query = EventQueryHandler.new
    @resultsAll = query.totalEvents
    @resultsValid = query.totalEventsHaventHappened
    @javascriptsArray = ApplicationHelper.includeJavascripts(COUNT_STATUS) 
    
    results = { all: @resultsAll, valid: @resultsValid }
    respond_to do |format|
      format.html
      format.json  { render :json => results }
    end
  end

  def all 
    @logo = LOGO
    @description = "Hidden Page"
    @title = "ALL"
    query = EventQueryHandler.new
    @results = query.getAllEvents
    @javascriptsArray = ApplicationHelper.includeJavascripts(RESULT_STATUS)

    respond_to do |format|
      format.html
      format.json  { render :json => @results }
    end
  end

  # POST /event_results
  # POST /event_results.json
  def create
    @javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS ); 
    @event_result = EventResult.new( event_result_params(params) )
    puts  event_result_params(params)
    respond_to do |format|
      if @event_result.save
        format.html { redirect_to @event_result, notice: 'Event result was successfully created.' }
        format.json { render :show, status: :created, location: @event_result }
      else
        format.html { render :new }
        format.json { render json: @event_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_results/1
  # PATCH/PUT /event_results/1.json
  def update
    @javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS ); 
    respond_to do |format|
      @event_result = EventResult.find(params[:id]); 
      if @event_result.update_attributes(event_result_params(params))
        format.html { redirect_to @event_result, notice: 'Event result was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_result }
      else
        format.html { render :edit }
        format.json { render json: @event_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_results/1
  # DELETE /event_results/1.json
  def destroy
    @javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS ); 
    @event_result.destroy
    respond_to do |format|
      format.html { redirect_to event_results_url, notice: 'Event result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def is_member 
      redirect_to access_denied_path if !logged_in?
    end

    def only_admin
      redirect_to access_denied_path if !is_admin
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_event_result
      @event_result = EventResult.find(params[:id])
    end

    def generateLocation(address)
      geo = Geocoder.coordinates(address)
      lat = geo.nil? ? "" : geo[0]
      long = geo.nil? ? "" : geo[1]
      return lat, long
    end 

    def createDateTime(start1, start2)
     start1[0] + " " + start2["(4i)"] + ":" + start2["(5i)"] + ":00"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_result_params(p)
      lat, long = generateLocation(p["event_result"][:address])
      { 
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
    end
end
