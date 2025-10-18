module SlackClient
  module Views
    class PuzzleForm
      def create
        blocks = Slack::BlockKit.blocks do |blocks|
          blocks.section do |section|
            section.mrkdwn text: intro_text
          end

          blocks.input label: "What is the Puzzle question?", block_id: "question" do |input|
              input.plain_text_input(
              action_id: "question",
              multiline: true,
              placeholder: "See template below"
            )
          end

          blocks.context do |context|
            context.mrkdwn text: "*Puzzle Examples*"
            context.plain_text text: placeholder_text
          end

          blocks.input label: "Answer", block_id: "answer" do |input|
            input.radio_buttons action_id: "answer" do |radio_button|
              radio_button.option text: "Ruby", value: "ruby"
              radio_button.option text: "Rails", value: "rails"
            end
          end

          blocks.input label: "Explanation", block_id: "explanation" do |input|
            input.plain_text_input action_id: "explanation", multiline: true
          end

          blocks.input label: "Link to documentation", block_id: "link", optional: true do |input|
            input.plain_text_input action_id: "link"
          end
        end

        Slack::BlockKit.modal blocks: blocks, external_id: "puzzle_form__#{SecureRandom.hex(6)}", title: "Suggest a Puzzle" do |modal|
          modal.submit text: "Submit"
          modal.close text: "Close"
        end.as_json
      end

      private

      def intro_text
        <<~TEXT
          Please provide a puzzle question, the answer, an explanation of the answer, and a link to documentation if applicable.

          When providing the question, please provide ONLY the question text, without any additional introduction (for example, do not include "Is this ruby or rails?"). The bot will add that automatically.
        TEXT
      end

      def placeholder_text
        <<~TEXT

          Example: Multi-line Snippet

          In this snippet:

          ```
          Time.current.strftime("%Y-%m-%dT%H:%M:%S%z")
          ```

          Is the `current` method a Ruby or Rails method?

          Example: Single Sentence Snippet

          When you have a line like this `hash = { a: 1, b: 2, c: 3 }` and later you call this method `hash.transform_keys(&:to_s)` -- is `transform_keys` a Ruby or Rails method?
        TEXT
      end
    end
  end
end
