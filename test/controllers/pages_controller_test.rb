require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get under_construction" do
    get pages_under_construction_url
    assert_response :success
  end
end
