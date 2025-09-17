module Discord
  # This class handles running and setting up the bot.
  class Bot
    class << self
      attr_accessor :configuration

      def configure
        self.configuration ||= Discord::Configuration.new
        if block_given?
          yield(configuration)
        end
        new(configuration)
      end
    end

    attr_accessor :bot

    delegate :send_message, to: :bot

    def initialize(configuration)
      @bot = Discordrb::Bot.new(token: configuration.token, log_mode: configuration.log_mode)
      @bot.ready do
        Rails.logger.info "✅ Bot is online and connected to Discord!"
        setup
      end
    end

    private

    def setup
      turn_events_on
    end

    def turn_events_on
      event_dir = Rails.root.join("app/lib/discord/events")
      Dir.foreach(event_dir) do |file|
        next if file == "." || file == ".." # Skip '.' and '..'
        event_class = "Discord::Events::#{file.chomp(".rb").camelize}".constantize
        event_class.new(@bot).try(:listen)
      end
      puts "Events registered. Bot is listening..."
    end
  end
end
