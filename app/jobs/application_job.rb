class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked
  def bot
    @bot ||= Discord::Bot.configure do |config|
      config.token = ENV.fetch("DISCORD_BOT_TOKEN", "")
    end
  end
end
