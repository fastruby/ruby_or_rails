module SlackClient
  module Views
    class Success
      def create
        blocks = Slack::BlockKit.blocks do |block|
          block.section do |section|
            section.mrkdwn text: ":white_check_mark: All set! Puzzle submitted!"
          end
        end
        Slack::BlockKit.modal blocks: blocks, title: "Thank you!" do |modal|
          modal.close text: "Close"
        end.as_json
      end
    end
  end
end
