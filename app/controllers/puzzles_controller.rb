class PuzzlesController < ApplicationController
  def index
    unless session[:user_token]
      render "login"
    end

    @pending_puzzles = Puzzle.pending
    @approved_puzzles = Puzzle.approved
    @rejected_puzzles = Puzzle.rejected
    @archived_puzzles = Puzzle.archived
  end
end
