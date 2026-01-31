ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Global setup to be run before each test
    setup do
      OmniAuth.config.mock_auth[:google] = nil
    end

    # Add more helper methods to be used by all tests here...
    def sign_in
      auth = {
        provider: "google_oauth2",
        uid: "123456789",
        info: {
          email: "cooper@ombulabs.com"
        },
        credentials: {
          token: "token"
        }
      }

      OmniAuth.config.add_mock(:google, auth)
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google]

      post sessions_path, params: { provider: :google }
    end
  end
end
