module Discord
  module Events
    class SetChannel
      def initialize(bot)
        @bot = bot
      end

      def listen
        # Listen for the set_channel command
        @bot.application_command(:set_channel) do |event|
          handle(event)
        end

        # Listen for select menu event
        listen_to_channel_select
      end

      def handle(event)
        user = event.user

        # Ensure the user has the necessary permissions to run the command
        unless user.permission?(:manage_server)
          event.respond("You do not have permission to run this command.")
          return
        end
        display_settings(event)
      end

      private

      def display_settings(event)
        content = <<~MSG
          Here you can configure the bot to suit the needs of the community!

          ⚠️ If you set this to a private channel, make sure to give the bot access to it, otherwise it can't send messages.

          What's the best channel to send Ruby or Rails questions to?
        MSG
        channel_select = Discordrb::Components::View.new do |view|
          view.row do |row|
            row.channel_select(custom_id: "set_channel_select", placeholder: "Discussion prompts channel")
          end
        end

        event.respond(content: content, ephemeral: true, components: channel_select)
      end

      def listen_to_channel_select
        # Listen for the channel select event
        @bot.channel_select(custom_id: "set_channel_select") do |event|
          channel = event.values.first  # Get the selected channel
          server = Server.find_by!(server_id: event.server.id)

          existing_channel = server.channel

          if existing_channel
            # If the channel exists, update it
            existing_channel.update!(name: channel.name, channel_id: channel.id)
          else
            # If the channel doesn't exist, create a new one associated with the server
            server.create_channel!(name: channel.name, channel_id: channel.id)
          end

          # Respond with a confirmation message
          event.respond(content: "Thank you! Ruby or Rails questions will be sent to #{channel.name} from now on.", ephemeral: true)
        end
      end
    end
  end
end
