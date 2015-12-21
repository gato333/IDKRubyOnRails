class EventResultsController < ApplicationController
  before_action :set_event_result, only: [:show, :edit, :update, :destroy]
  include ApplicationHelper 

  # GET /event_results
  # GET /event_results.json
  def index
    @javascriptsArray = ApplicationHelper.includeJavascripts(ApplicationHelper::DEFAULT_STATUS); 
    @event_results = EventResult.all
  end

  # GET /event_results/1
  # GET /event_results/1.json
  def show
    @javascriptsArray = ApplicationHelper.includeJavascripts(ApplicationHelper::PAGE_STATUS); 
  end

  # GET /event_results/new
  def new
    @javascriptsArray = ApplicationHelper.includeJavascripts(ApplicationHelper::DEFAULT_STATUS); 
    @event_result = EventResult.new
  end

  # GET /event_results/1/edit
  def edit
    @javascriptsArray = ApplicationHelper.includeJavascripts(ApplicationHelper::DEFAULT_STATUS); 
  end

  # POST /event_results
  # POST /event_results.json
  def create
    @javascriptsArray = ApplicationHelper.includeJavascripts(ApplicationHelper::DEFAULT_STATUS); 
    @event_result = EventResult.new( event_result_params(params) )

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
    @javascriptsArray = ApplicationHelper.includeJavascripts(ApplicationHelper::DEFAULT_STATUS); 
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
    @javascriptsArray = ApplicationHelper.includeJavascripts(ApplicationHelper::DEFAULT_STATUS); 
    @event_result.destroy
    respond_to do |format|
      format.html { redirect_to event_results_url, notice: 'Event result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_result
      @event_result = EventResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_result_params(p)
      { 
        "name" => p["event_result"][:name], 
        "lat" => p["event_result"][:lat], 
        "long" => p["event_result"][:long], 
        "address" => p["event_result"][:address], 
        "eventurl" => p["event_result"][:eventurl], 
        "imageurl" => p["event_result"][:imageurl], 
        "startdate" => p["event_result"][:startdate], 
        "enddate" => p["event_result"][:enddate], 
        "source" => p["event_result"][:source], 
        "types" => p["event_result"][:types], 
        "price" => p["event_result"][:price], 
        "description" => p["event_result"][:description]
      }
    end
end
