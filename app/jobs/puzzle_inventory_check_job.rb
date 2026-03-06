class PuzzleInventoryCheckJob < ApplicationJob
  queue_as :default
  retry_on StandardError, attempts: 3

  def perform
    approved_unsent_puzzle_count = Puzzle.approved.where(sent_at: nil).count

    if approved_unsent_puzzle_count < 5
      send_low_inventory_notification(approved_unsent_puzzle_count)
    end
  end

  private

  def send_low_inventory_notification(count)
    channel_id = ENV["SHIELD_NOTIFICATIONS_CHANNEL"]
    return Rails.logger.warn("SHIELD_NOTIFICATIONS_CHANNEL is not configured, skipping low inventory notification") unless channel_id

    notification_message = SlackClient::Messages::LowPuzzleInventoryNotification.new(count).create
    send_message(notification_message, channel_id: channel_id)
  end

  def send_message(message, channel_id:)
    SlackClient::Client.instance.chat_postMessage(channel: channel_id, blocks: message)
  rescue Slack::Web::Api::Errors::SlackError => e
    Sentry.capture_exception(e)
    Rails.logger.error "Failed to send Slack message: #{e.message} #{e.response_metadata}"
  end
end
