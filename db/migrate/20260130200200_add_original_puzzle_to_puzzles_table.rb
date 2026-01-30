class AddOriginalPuzzleToPuzzlesTable < ActiveRecord::Migration[8.0]
  def change
    add_reference :puzzles, :original_puzzle, foreign_key: { to_table: :puzzles }, index: true, null: true
  end
end
