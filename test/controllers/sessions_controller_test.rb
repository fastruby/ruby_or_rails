require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "completes OAuth even when session has expired" do
    # Sign in so the session gets an expires_at timestamp.
    sign_in

    # Travel past the expiry window so check_session_expiry would fire.
    # Without the fix, it renders puzzles/login and the OAuth callback never completes.
    travel_to 2.hours.from_now do
      sign_in
      assert_redirected_to root_path
    end
  end
end
