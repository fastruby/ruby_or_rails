module Discord
  module Events
    # This class listens and handles the event triggered when the bot is removed from a server.
    class ServerDelete
      def initialize(bot)
        @bot = bot
      end

      def listen
        @bot.server_delete do |event|
          handle(event)
        end
      end

      def handle(event)
        begin
          server_id = event.server
        rescue Discordrb::Errors::UnknownServer
          # This error is expected when the bot is removed from a server
          puts "Bot was removed from an unknown server"
          return
        end

        server = Server.find_by(server_id: server_id)
        server&.update!(active: false)
      end

      private

      attr_reader :bot
    end
  end
end
