require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get create_event" do
    get admin_create_event_url
    assert_response :success
  end
end
