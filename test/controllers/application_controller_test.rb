require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  include ApplicationHelper 

  DO_STATUS = ApplicationHelper::DO_STATUS
  DEFAULT_STATUS = ApplicationHelper::DEFAULT_STATUS
  RANDOM_STATUS = ApplicationHelper::RANDOM_STATUS
  RESULT_STATUS = ApplicationHelper::RESULT_STATUS
  COUNT_STATUS = ApplicationHelper::COUNT_STATUS

  LOGO = ApplicationHelper::LOGO
  DESCRIPTION = ApplicationHelper::DESCRIPTION

  def setup 
    @logo = LOGO
    @base_title = " | I Dont Know - WebApp"
    @description = DESCRIPTION
    @event = EventResult.first
    @javascriptsArray = ApplicationHelper.includeJavascripts(DEFAULT_STATUS); 
  end

  test "should get about" do
    get :home
    assert_response :success
    assert_select "title", "ABOUT" + @base_title
  end

  test "should get search" do

    @javascriptsArray = ApplicationHelper.includeJavascripts(DO_STATUS); 
    get :do
    assert_response :success
    assert_select "title", "SEARCH" + @base_title
  end

  test "should get random" do

    @javascriptsArray = ApplicationHelper.includeJavascripts(RANDOM_STATUS); 
    get :random
    assert_response :success
    assert_select "title", "RANDOM" + @base_title
  end

  test "should get results" do

    @javascriptsArray = ApplicationHelper.includeJavascripts(RESULT_STATUS); 
    get( :results, 
      { 'radius' => "10", 'lat' => "40.727", 'long' => "-73.977", 
        'source' => 'DO', 'price' => '', 'keyword' => ''} )
    assert_response :success
    assert_select "title", "SEARCH" + @base_title
  end

  test "should get all" do

    @javascriptsArray = ApplicationHelper.includeJavascripts(RESULT_STATUS);
    get :all
    assert_response :success
    assert_select "title", "ALL" + @base_title
  end

  test "should get count" do

    @javascriptsArray = ApplicationHelper.includeJavascripts(COUNT_STATUS); 
    get :count
    assert_response :success
    assert_select "title", "COUNT" + @base_title
  end

  test "should get error" do
    get :error
    assert_response :success
    assert_select "title", "ERROR" + @base_title
  end
end
