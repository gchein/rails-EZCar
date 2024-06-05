require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "should get edit" do
    get bookings_edit_url
    assert_response :success
  end

  test "should get update" do
    get bookings_update_url
    assert_response :success
  end
end
