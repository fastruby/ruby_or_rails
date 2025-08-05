require "singleton"

module SlackClient
  # This class is a wrapper around the Slack::Web::Client class that allows us to use the
  # singleton pattern to create a single instance of the Slack client.
  # This is useful because we can reuse the same client instance across the application,
  # which can help reduce the number of connections to the Slack API.
  #
  # Example:
  # slack_client = SlackClient::Client.instance
  #
  class Client
    include Singleton

    def initialize
      @slack_client = Slack::Web::Client.new(token: ENV["SLACK_TOKEN"])
    end

    private

    def method_missing(method, *args, &block)
      if @slack_client.respond_to?(method)
        @slack_client.send(method, *args, &block)
      else
        super
      end
    rescue Slack::Web::Api::Errors::SlackError => e
      Rails.logger.error "Failed to complete Slack request: #{e.message} #{e.response_metadata}"
      raise
    end

    def respond_to_missing?(method, include_private = false)
      @slack_client.respond_to?(method) || super
    end
  end
end
