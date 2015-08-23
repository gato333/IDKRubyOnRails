require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  def setup 
    @base_title = "I Dont Know - WebApp"
  end

  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "HOME | #{@base_title}"
  end

  test "should get do" do
    get :do
    assert_response :success
    assert_select "title", "DO | #{@base_title}"
  end

  test "should get eat" do
    get :eat
    assert_response :success
    assert_select "title", "EAT | #{@base_title}"
  end

  test "should get random" do
    get :random
    assert_response :success
    assert_select "title", "RANDOM | #{@base_title}"
  end

  test "should get results" do
    get :results
    assert_response :success
    assert_select "title", "RESULTS | #{@base_title}"
  end

end
