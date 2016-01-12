require 'test_helper'

class EventResultTest < ActiveSupport::TestCase
  def setup
    @event = EventResult.new( 
        name: "example name", 
        price: 999, 
        lat: 54.09, 
        long: 34.09, 
        address: "124 street st. New York, NY 10010", 
        imageurl: "http://34.media.tumblr.com/avatar_a50ecc8879f8_128.png", 
        eventurl: "artgato.com" , 
        startdate: "01-12-2015 05:00:00", 
        enddate: "01-12-2015 010:00:00", 
        description: "I am a description for an example event", 
        types: "example types", 
        source: "gabby" 
    )
  end

  test "should be valid" do
    assert @event.valid?
  end

  test "name should be present" do
    @event.name = "     "
    assert_not @event.valid?
  end

  test "eventurl should be present" do
    @event.eventurl = "      "
    assert_not @event.valid?
  end

  test "address should be present" do
    @event.address = "      "
    assert_not @event.valid?
  end

  test "event should be unique" do
    duplicate_user = @event.dup
    @event.save
    assert_not duplicate_user.valid?
  end

end
