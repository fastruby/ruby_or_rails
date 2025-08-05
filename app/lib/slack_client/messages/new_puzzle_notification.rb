module SlackClient
  module Messages
    class NewPuzzleNotification
      def initialize(puzzle, slack_group_id: ENV["SLACK_GROUP_ID"])
        @puzzle = puzzle
        @slack_group_id = slack_group_id
      end

      def create
        Slack::BlockKit.blocks do |block|
          block.section do |section|
            section.mrkdwn text: "*New Puzzle Suggestion!*\n\n"
          end
          block.section do |section|
            section.mrkdwn text: body_text
          end
        end.as_json
      end

      private

      def body_text
        <<~TEXT
          Hey <!subteam^#{@slack_group_id}>!

          <@#{@puzzle.suggested_by}> has submitted a new suggestion for a puzzle:

          Question:
          #{@puzzle.question}

          Check out the <#{ENV.fetch('APP_URL', nil)}|admin panel> for more details.
        TEXT
      end
    end
  end
end
