require "test_helper"

class CarsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get cars_show_url
    assert_response :success
  end
end
