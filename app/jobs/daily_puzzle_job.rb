class DailyPuzzleJob < ApplicationJob
  queue_as :default
  retry_on StandardError, attempts: 3

  def perform
    puzzle = Puzzle.where(sent_at: nil, state: 0).order("RANDOM()").first
    return unless puzzle

    Server.where(active: true).each do |server|
      channel = server.channel
      next unless channel

      bot.send_message(
        channel.channel_id,
        "",
        false,
        puzzle_embed(puzzle),
        nil,
        nil,
        nil,
        puzzle_buttons(puzzle.id)
      )
    end

    puzzle.update!(sent_at: Time.current, state: :archived)
  end

  private

  def puzzle_embed(puzzle)
    Discordrb::Webhooks::Embed.new(
      title: "Puzzle Time! 🧩",
      description: puzzle.question,
      color: 0x3498db # Blue color
    )
  end

  def puzzle_buttons(puzzle_id)
    Discordrb::Webhooks::View.new do |view|
      view.row do |row|
        row.button(
          style: :primary,
          emoji: ENV["RUBY_EMOJI_ID"] || "🔴",
          label: "Ruby",
          custom_id: "ruby__#{puzzle_id}"
        )
        row.button(
          style: :primary,
          emoji: ENV["RAILS_EMOJI_ID"] || "🚂",
          label: "Rails",
          custom_id: "rails__#{puzzle_id}"
        )
      end
    end
  end
end
