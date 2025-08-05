module SlackClient
  module Messages
    class LowPuzzleInventoryNotification
      def initialize(count, shield_group_id: ENV["SHIELD_GROUP_ID"])
        @count = count
        @shield_group_id = shield_group_id
      end

      def create
        Slack::BlockKit.blocks do |block|
          block.header text: "⚠️ Puzzle Inventory Alert ⚠️"
          block.section do |section|
            section.mrkdwn text: body_text
          end
        end.as_json
      end

      private

      def body_text
        <<~TEXT
          Hey <!subteam^#{@shield_group_id}>!

          There are currently *only #{@count} approved puzzles* in the database. This is below the minimum threshold of 5 puzzles.

          Please add more puzzles so we don't run out!
        TEXT
      end
    end
  end
end
