class PuzzleInventoryCheckJob < ApplicationJob
  queue_as :default
  retry_on StandardError, attempts: 3

  def perform
    approved_unsent_puzzle_count = Puzzle.where(state: 0, sent_at: nil).count

    if approved_unsent_puzzle_count < 5
      send_low_inventory_notification(approved_unsent_puzzle_count)
    end
  end

  private

  def send_low_inventory_notification(count)
    notification_message = SlackClient::Messages::LowPuzzleInventoryNotification.new(count).create
    send_message(notification_message, channel_id: ENV.fetch("SHIELD_NOTIFICATIONS_CHANNEL", nil))
  end

  def send_message(message, channel_id:)
    SlackClient::Client.instance.chat_postMessage(channel: channel_id, blocks: message)
  rescue Slack::Web::Api::Errors::SlackError
    head :unprocessable_entity
  end
end
