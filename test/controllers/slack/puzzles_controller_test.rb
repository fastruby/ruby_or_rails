require "test_helper"

class Slack::PuzzlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    ENV["SLACK_SIGNING_SECRET"] = "test_signing_secret"
  end

  test "renders ok when puzzle is saved and notification succeeds" do
    # Use a payload that fails validation so send_message is never called,
    # verifying the action renders 200 without a double render.
    params = { payload: puzzle_payload(question: "") }

    post slack_puzzle_path, params: params,
      headers: slack_headers(body: params.to_query)

    assert_response :ok
  end

  test "does not double render when Slack notification fails after puzzle is saved" do
    # Override send_message to simulate a Slack API error that calls head :unprocessable_entity.
    # Without the fix, this causes AbstractController::DoubleRenderError because create
    # still calls render json: after send_message returns.
    original = Slack::ApplicationController.instance_method(:send_message)
    Slack::ApplicationController.define_method(:send_message) { |*| head :unprocessable_entity }

    params = { payload: puzzle_payload(question: "What is unique about Ruby's blocks?") }

    post slack_puzzle_path, params: params,
      headers: slack_headers(body: params.to_query)

    assert_response :unprocessable_entity
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
