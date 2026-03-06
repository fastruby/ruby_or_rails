require "test_helper"

class Slack::PuzzlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    ENV["SLACK_SIGNING_SECRET"] = "test_signing_secret"
  end

  test "rejects request with invalid Slack signature" do
    post slack_puzzle_path, params: { payload: puzzle_payload },
      headers: slack_headers(secret: "wrong_secret")

    assert_response :unauthorized
  end

  test "rejects request with expired Slack timestamp" do
    post slack_puzzle_path, params: { payload: puzzle_payload },
      headers: slack_headers(timestamp: Time.now.to_i - 400)

    assert_response :unauthorized
  end

  test "allows request with valid Slack signature" do
    # Use a payload that fails model validation so no Slack API call is made,
    # but the controller still renders 200 (its behavior on both save success/failure).
    params = { payload: puzzle_payload(question: "") }

    post slack_puzzle_path, params: params,
      headers: slack_headers(body: params.to_query)

    assert_response :ok
  end

  private

  def puzzle_payload(question: "What is Ruby?")
    {
      user: { id: "U123" },
      view: {
        state: {
          values: {
            question: { question: { value: question } },
            answer: { answer: { selected_option: { value: "ruby" } } },
            explanation: { explanation: { value: "It is a programming language." } },
            link: { link: { value: nil } }
          }
        }
      }
    }.to_json
  end

  def slack_headers(secret: ENV["SLACK_SIGNING_SECRET"], timestamp: Time.now.to_i, body: "")
    ts = timestamp.to_s
    sig = "v0=" + OpenSSL::HMAC.hexdigest("SHA256", secret, "v0:#{ts}:#{body}")
    { "X-Slack-Request-Timestamp" => ts, "X-Slack-Signature" => sig }
  end
end
