module Puzzles
  class StatesController < ApplicationController
    def update
      puzzle = Puzzle.find(params[:puzzle_id])
      if puzzle.update(state: params[:state])
        redirect_to puzzles_path, notice: "Puzzle state updated to #{puzzle.state}."
      else
        redirect_to puzzles_path, alert: "Failed to update puzzle state."
      end
    end
  end
end
