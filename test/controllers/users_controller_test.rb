require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include ApplicationHelper 

  LOGO = ApplicationHelper::LOGO
  DESCRIPTION = ApplicationHelper::DESCRIPTION

  DEFAULT_STATUS = ApplicationHelper::DEFAULT_STATUS

  def setup 
    @logo = LOGO
    @user = User.first
    @base_title = " | I Dont Know - WebApp"
    @description = DESCRIPTION
    @javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS ); 
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_select "title", "USER INDEX" + @base_title
  end

  test "should get show" do
    get(:show, {'id' =>  @user.id.to_s}, {'user_id' => @user.id})
    assert_response :success
    assert_select "title", "SHOW USER " + @user.id.to_s + @base_title
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", "NEW USER" + @base_title
  end

  test "should get edit" do
    get(:edit, {'id' =>  @user.id.to_s}, {'user_id' => @user.id})
    assert_response :success
    assert_select "title", "EDIT USER " + @user.id.to_s + @base_title
  end

end
