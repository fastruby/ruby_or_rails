module Discord
  module Events
    # This class listens and handles the event triggered when the help command is triggered.
    class HelpCommand
      def initialize(bot)
        @bot = bot
      end

      def listen
        @bot.application_command(:help) { |event| handle(event) }
      end

      def handle(event)
        event.respond(content: "", embeds: [ help_message ], ephemeral: true)
      end

      private

      def help_message
        embed = Discordrb::Webhooks::Embed.new(
          title: "Is it Ruby or Rails?",
          description: "I'm here to test your knowledge on whether something is Ruby or Rails! Every day I'll send a question to see if you can guess correctly. Good luck!",
          color: 0xe60000
        )
        embed.add_field(name: "🧩 Daily Puzzles", value: "You can only answer a question once, but you can revisit older questions you haven't answered yet.")
        embed.add_field(name: "❓Immediate Feedback", value: "As soon as you give your answer, I'll let you know if you're right or wrong and why.")
        embed.add_field(name: "🏆 Leaderboard", value: "I'll send you a leaderboard at the end of each week, so you know who's the Ruby or Rails expert of the week!")
        embed.add_field(name: "⚙️ Admin Commands", value: "")
        embed.add_field(name: "/set_channel", value: "Specify which channel I should post to within the server.")
        embed
      end
    end
  end
end
