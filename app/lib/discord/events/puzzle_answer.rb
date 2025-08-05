module Discord
  module Events
    class PuzzleAnswer
      def initialize(bot)
        @bot = bot
      end

      def listen
        # Listen for button clicks and filter based on custom_id pattern
        @bot.button { |event| handle(event) if valid_puzzle_answer?(event) }
      end

      def handle(event)
        answer, puzzle_id = event.custom_id.split("__")

        # Find the associated puzzle
        puzzle = find_puzzle(puzzle_id.to_i)
        return unless puzzle

        # Find or create the user
        user = User.find_or_initialize_by(user_id: event.user.id)
        user.assign_attributes(
          username: event.user.username,
          # Users with permission to manage the server are admins, all other users fall under the member role
          role: event.user.permission?(:manage_server) ? 1 : 0
        )
        user.save if user.changed?

        # Find server
        server = Server.find_by(server_id: event.server.id)

        # Check if the user has already answered this puzzle
        existing_answer = Answer.find_by(puzzle_id: puzzle.id, user_id: user.id, server_id: server.id)
        if existing_answer
          # If the user has already answered, prevent them from changing their answer
          event.respond(
            content: "You have already answered this puzzle. You cannot change your answer.",
            ephemeral: true # Only the user sees this message
          )
          return
        end

        server = Server.find_or_initialize_by(server_id: event.server.id)

        # Create the answer record
        answer = Answer.create!(
          puzzle_id: puzzle.id,
          user_id: user.id,
          server_id: server.id,
          choice: answer, # 'ruby' or 'rails'
          is_correct: puzzle.answer.to_s == answer # Correct answer check
        )

        # Respond to the user with the result
        event.respond(
          content: nil,
          embeds: [ answer_embed(answer, puzzle) ],
          ephemeral: true # Only the user sees this message
        )
      end

      private

      def answer_embed(answer, puzzle)
        embed = Discordrb::Webhooks::Embed.new(
          title: answer.is_correct ? "Correct! 🎉" : "Incorrect 😢",
          description: puzzle.explanation,
          color: answer.is_correct ? 0x00ff00 : 0xe60000,
          footer: Discordrb::Webhooks::EmbedFooter.new(text: "Your answer has been recorded, you cannot change it.")
        )
        if puzzle.link
          embed.add_field(name: "Learn more", value: puzzle.link, inline: false)
        end
        embed
      end

      def valid_puzzle_answer?(event)
        # Check if the custom_id matches the pattern (ruby__NUMBER or rails__NUMBER)
        event.custom_id.match?(/^(ruby|rails)__\d+$/)
      end

      def find_puzzle(puzzle_id)
        Puzzle.find_by(id: puzzle_id)
      end
    end
  end
end
