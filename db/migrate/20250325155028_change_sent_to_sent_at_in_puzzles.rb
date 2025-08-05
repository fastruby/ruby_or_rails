class ChangeSentToSentAtInPuzzles < ActiveRecord::Migration[8.0]
  def change
    remove_column :puzzles, :sent, :boolean
    add_column :puzzles, :sent_at, :datetime
  end
end
