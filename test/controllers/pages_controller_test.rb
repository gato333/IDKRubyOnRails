require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get do" do
    get :do
    assert_response :success
  end

  test "should get eat" do
    get :eat
    assert_response :success
  end

  test "should get random" do
    get :random
    assert_response :success
  end

end
