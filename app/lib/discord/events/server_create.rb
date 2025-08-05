module Discord
  module Events
    # This class listens and handles the event triggered when the bot joins a server.
    class ServerCreate
      def initialize(bot)  # Ensure we accept a bot instance here
        @bot = bot
      end

      def listen
        @bot.server_create { |event| handle(event) }
      end

      def handle(event)
        # Send the introduction message to the main server channel.
        server = event.server
        system_channel = server.system_channel

        # Ensure system_channel exists and send a message to the server
        if system_channel
          system_channel.send_message("", false, welcome_message(server.name))
        else
          puts "No suitable channel found to add the bot to."
        end

        create_or_update_server(server)
      end

      private

      def welcome_message(server_name)
        embed = Discordrb::Webhooks::Embed.new(
          title: "Hello #{server_name}!",
          description: "I am the 'Is it Ruby or Rails' bot! I will be sending a question every day to see if you know what is Ruby and what is Rails! Good luck!",
          color: 0xe60000
        )
        embed.add_field(name: "🧩 Daily Puzzles", value: "You can only answer a question once, but you can revisit older questions you haven't answered yet.")
        embed.add_field(name: "🏆 Leaderboard", value: "I'll send you a leaderboard at the end of each week, so you know who's the Ruby or Rails expert of the week!")
        embed.add_field(name: "⚙️ Admin Commands", value: "")
        embed.add_field(name: "/set_channel", value: "Specify which channel I should post to within the server.")
        embed
      end

      attr_reader :bot

      def create_or_update_server(server)
        # Find or create the Server record
        discord_server = Server.find_or_create_by(server_id: server.id) do |s|
          s.name = server.name
          s.active = true
        end

        # Update the server name if it changed
        discord_server.update!(name: server.name, active: true)

        # Update or create a system channel is one is set
        if server.system_channel
          create_or_update_system_channel(server, discord_server)
        end
      end

      def create_or_update_system_channel(server, discord_server)
        if discord_server.channel
          discord_server.channel.update!(
            channel_id: server.system_channel.id,
            name: server.system_channel.name
          )
        else
          discord_server.create_channel!(
            channel_id: server.system_channel.id,
            name: server.system_channel.name
          )
        end
      end
    end
  end
end
