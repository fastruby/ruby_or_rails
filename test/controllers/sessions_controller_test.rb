require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "completes OAuth even when session has expired" do
    sign_in

    travel_to 2.hours.from_now do
      sign_in
      assert_redirected_to root_path
    end
  end
end
