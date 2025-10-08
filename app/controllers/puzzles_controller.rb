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

    respond_to do |format|
      if @puzzle.update(puzzle_params)
        format.turbo_stream
        format.html { redirect_to puzzles_path, notice: "Puzzle updated." }
        format.json { render json: { success: true, puzzle: @puzzle } }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("modal", partial: "puzzles/edit_modal", locals: { puzzle: @puzzle }), status: :unprocessable_entity }
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
