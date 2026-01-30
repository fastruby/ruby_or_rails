class Puzzles::ClonesController < ApplicationController
  def create
    original_puzzle = Puzzle.find(params[:puzzle_id])
    attributes = original_puzzle.attributes.slice("question", "answer", "explanation", "link", "suggested_by")
    cloned_puzzle = Puzzle.new(attributes.merge(original_puzzle:, state: params.fetch(:state, "pending")))

    if cloned_puzzle.save
      redirect_to puzzles_path, notice: "Puzzle cloned. You can now edit the new puzzle."
    else
      redirect_to puzzles_path, alert: "Failed to clone puzzle."
    end
  end
end
