module SlackClient
  module Views
    class Failure
      def create
        blocks = Slack::BlockKit.blocks do |block|
          block.section do |section|
            section.plain_text text: ":blob-no: Sorry, I could not register the puzzle suggestion."
          end
        end
        Slack::BlockKit.modal blocks: blocks, title: "Uh oh..." do |modal|
          modal.close text: "Close"
        end.as_json
      end
    end
  end
end
