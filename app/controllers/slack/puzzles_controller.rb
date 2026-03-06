class Slack::PuzzlesController < Slack::ApplicationController
  def create
    payload = JSON.parse(params[:payload])
    user_id = payload["user"]["id"]
    values = payload["view"]["state"]["values"]
    question = values.dig("question", "question", "value")
    answer = values.dig("answer", "answer", "selected_option", "value")
    explanation = values.dig("explanation", "explanation", "value")
    link = values.dig("link", "link", "value")
    puzzle = Puzzle.new(question:, answer:, explanation:, link:, state: :pending, suggested_by: user_id)

    if puzzle.save
      view = SlackClient::Views::Success.new.create
      notification_message = SlackClient::Messages::NewPuzzleNotification.new(puzzle).create
      send_message(notification_message, channel_id: ENV.fetch("SLACK_NOTIFICATIONS_CHANNEL", nil))
    else
      view = SlackClient::Views::Failure.new.create
    end

    render json: { response_action: "update", view: view }, status: :ok
  end
end
