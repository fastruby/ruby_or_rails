namespace :discord do
  desc "Configure and run the discord bot"
  task start_bot: :environment do
    bot.run
  end

  desc "Clear all globally registered bot commands and re-register them"
  task reset_commands: :environment do
    # Fetch and delete all existing commands
    commands = bot.get_application_commands
    commands.each do |command|
      bot.delete_application_command(command.id)
    end

    puts "✅ Cleared all global commands. Now re-registering..."

    # Register the commands again
    bot.register_application_command(:set_channel, "Set a channel for bot to be used in.")
    bot.register_application_command(:help, "Get help on how to use the bot.")

    puts "✅ Re-registered commands!"
  end
end

def bot
  @bot ||= begin
    bot_wrapper = Discord::Bot.configure do |config|
      config.token = ENV.fetch("DISCORD_BOT_TOKEN")
    end
    bot_wrapper.bot
  end
end
