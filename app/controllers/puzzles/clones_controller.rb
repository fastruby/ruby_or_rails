class Puzzles::ClonesController < ApplicationController
  def create
    original_puzzle = Puzzle.find(params[:puzzle_id])
    cloned_puzzle = original_puzzle.clone

    if cloned_puzzle.persisted?
      redirect_to puzzles_path, notice: "Puzzle cloned. You can now edit the new puzzle."
    else
      redirect_to puzzles_path, alert: "Failed to clone puzzle."
    end
  end
end
