require 'test_helper'

class EventResultsControllerTest < ActionController::TestCase
  include ApplicationHelper 

  LOGO = ApplicationHelper::LOGO
  DESCRIPTION = ApplicationHelper::DESCRIPTION

  DEFAULT_STATUS = ApplicationHelper::DEFAULT_STATUS
  SHOW_STATUS = ApplicationHelper::SHOW_STATUS
  EDIT_STATUS = ApplicationHelper::EDIT_STATUS

  def setup 
    @logo = LOGO
    @event = EventResult.first
    @base_title = " | I Dont Know - WebApp"
    @description = DESCRIPTION
    @javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS ); 
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_select "title", "INDEX" + @base_title
  end

  test "should get show" do
    @javascriptsArray = ApplicationHelper.includeJavascripts(SHOW_STATUS); 
    get :show
    assert_response :success
    assert_select "title", "SHOW " + @event.id.to_s + " " + @base_title
  end

  test "should get new" do
    @javascriptsArray = ApplicationHelper.includeJavascripts(EDIT_STATUS); 
    get :new
    assert_response :success
    assert_select "title", "NEW" + @base_title
  end

  test "should get edit" do
    @javascriptsArray = ApplicationHelper.includeJavascripts(EDIT_STATUS); 
    get :edit
    assert_response :success
    assert_select "title", "EDIT " + @event.id.to_s + " " + @base_title
  end

end
