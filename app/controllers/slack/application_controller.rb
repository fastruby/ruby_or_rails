class Slack::ApplicationController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :valid_slack_request?

  private

  def valid_slack_request?
    @verified ||= verify_slack_signature
  end

  def verify_slack_signature
    timestamp = request.headers["X-Slack-Request-Timestamp"]
    signature = request.headers["X-Slack-Signature"]

    if Time.now.to_i - timestamp.to_i > 300
      @verified = false
      return
    end

    base_string = "v0:#{timestamp}:#{request.raw_post}"
    my_signature = "v0=" + OpenSSL::HMAC.hexdigest(
      "SHA256",
      ENV["SLACK_SIGNING_SECRET"],
      base_string
    )

    ActiveSupport::SecurityUtils.secure_compare(signature, my_signature)
  end

  def slack_client
    @slack_client ||= SlackClient::Client.instance
  end

  def open_view(view, trigger_id:)
    slack_client = SlackClient::Client.instance
    slack_client.views_open view: view, trigger_id: trigger_id
  rescue Slack::Web::Api::Errors::SlackError => e
    Rails.logger.error "Failed to open Slack modal: #{e.message} #{e.response_metadata}"
    head :unprocessable_entity
  end

  def send_message(message, channel_id:)
    SlackClient::Client.instance.chat_postMessage(channel: channel_id, blocks: message)
  rescue Slack::Web::Api::Errors::SlackError
    head :unprocessable_entity
  end
end
