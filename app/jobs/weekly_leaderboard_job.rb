class WeeklyLeaderboardJob < ApplicationJob
  queue_as :default
  retry_on StandardError, attempts: 3

  def perform
    start_time = Time.now.utc.beginning_of_week.beginning_of_day # Monday at 00:00 UTC
    end_time = Time.now.utc.end_of_week.end_of_day # Sunday at 23:59 UTC

    leaderboard_data = Answer
      .joins(:puzzle)
      .where(created_at: start_time..end_time, is_correct: true, puzzles: { sent_at: start_time..end_time })
      .group(:server_id, :user_id)
      .order(Arel.sql("COUNT(*) DESC"))
      .count

    return if leaderboard_data.empty?
    leaderboard_by_server = leaderboard_data.group_by { |(server_id, _), _| server_id }

    Server.all.each do |server|
      channel = server.channel
      next unless channel

      server_leaderboard = leaderboard_by_server[server.id]
      next unless server_leaderboard.present?

      leaderboard = server_leaderboard.map { |(_server_id, user_id), count| [ user_id, count ] }.to_h

      bot.send_message(
        channel.channel_id,
        "",
        false,
        leaderboard_embed(leaderboard),
        nil,
        nil,
        nil,
        nil
      )
    end
  end

  private

  def leaderboard_embed(leaderboard_data)
    description =
      if leaderboard_data.size > 10
        "Here are the top 10 players from this week's competition!"
      else
        "Here are the top players from this week's competition!"
      end
    embed = Discordrb::Webhooks::Embed.new(
      title: "🏆 Weekly Leaderboard 🏆",
      description: description,
      color: 0xFFD700 # Gold color
    )

    # Group leaderboard data by score
    grouped_by_score = leaderboard_data.group_by { |_, score| score }

    previous_score = nil
    rank = 0
    displayed_count = 0

    # Iterate over the grouped leaderboard data
    grouped_by_score.sort_by { |score, _| -score }.each do |score, users|
      users.each do |user_id, _|
        user = User.find(user_id)

        rank += 1 if score != previous_score
        previous_score = score

        break if displayed_count >= 10

        embed.add_field(name: "##{rank}    |    #{user.username}    |    #{score} points\n", value: "", inline: false)
        displayed_count += 1
      end
    end

    embed
  end
end
