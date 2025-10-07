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

  def edit
    @puzzle = Puzzle.find(params[:id])
  end

  def update
    @puzzle = Puzzle.find(params[:id])
    if @puzzle.update(puzzle_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to puzzles_path, notice: "Puzzle updated." }
        format.json { render json: { success: true, puzzle: @puzzle } }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@puzzle, partial: "puzzles/form", locals: { puzzle: @puzzle }) }
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @puzzle.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def puzzle_params
    params.require(:puzzle).permit(:question, :answer, :explanation, :link)
  end
end
