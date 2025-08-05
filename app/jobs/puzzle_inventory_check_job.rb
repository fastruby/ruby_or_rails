class PuzzleInventoryCheckJob < ApplicationJob
  queue_as :default
  retry_on StandardError, attempts: 3

  def perform
    approved_puzzle_count = Puzzle.where(state: 0).count

    if approved_puzzle_count < 5
      send_low_inventory_notification(approved_puzzle_count)
    end
  end

  private

  def send_low_inventory_notification(count)
    notification_message = SlackClient::Messages::LowPuzzleInventoryNotification.new(count).create
    send_message(notification_message, channel_id: ENV.fetch("SHIELD_NOTIFICATIONS_CHANNEL", nil))
  end
end
