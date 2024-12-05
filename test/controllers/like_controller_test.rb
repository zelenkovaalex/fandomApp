require "test_helper"

class LikeControllerTest < ActionDispatch::IntegrationTest
  test "should get toggle" do
    get like_toggle_url
    assert_response :success
  end
end
