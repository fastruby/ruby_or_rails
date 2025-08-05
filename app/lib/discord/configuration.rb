module Discord
  # This class encapsulates the configuration used by the discord bot.
  class Configuration
    attr_accessor :token, :log_mode

    def initialize
      @token = nil
    end
  end
end
