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

  test "renders ok when puzzle fails validation" do
    params = { payload: puzzle_payload(question: "") }

    post slack_puzzle_path, params: params,
      headers: slack_headers(body: params.to_query)

    assert_response :ok
  end

  test "renders ok even when Slack notification fails after puzzle is saved" do
    original = Slack::ApplicationController.instance_method(:send_message)
    Slack::ApplicationController.define_method(:send_message) { |*| nil }

    params = { payload: puzzle_payload(question: "What is unique about Ruby's blocks?") }

    post slack_puzzle_path, params: params,
      headers: slack_headers(body: params.to_query)

    assert_response :ok
  ensure
    Slack::ApplicationController.define_method(:send_message, original)
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
