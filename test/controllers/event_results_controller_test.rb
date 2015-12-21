require 'test_helper'

class EventResultsControllerTest < ActionController::TestCase
  setup do
    @event_result = event_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:event_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event_result" do
    assert_difference('EventResult.count') do
      post :create, event_result: {  }
    end

    assert_redirected_to event_result_path(assigns(:event_result))
  end

  test "should show event_result" do
    get :show, id: @event_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @event_result
    assert_response :success
  end

  test "should update event_result" do
    patch :update, id: @event_result, event_result: {  }
    assert_redirected_to event_result_path(assigns(:event_result))
  end

  test "should destroy event_result" do
    assert_difference('EventResult.count', -1) do
      delete :destroy, id: @event_result
    end

    assert_redirected_to event_results_path
  end
end
