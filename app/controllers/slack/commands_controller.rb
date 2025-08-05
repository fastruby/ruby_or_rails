class Slack::CommandsController < Slack::ApplicationController
  def new_puzzle
    view  = SlackClient::Views::PuzzleForm.new.create
    open_view(view, trigger_id: params[:trigger_id])
  end
end
