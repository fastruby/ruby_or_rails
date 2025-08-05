class AddSentToPuzzle < ActiveRecord::Migration[8.0]
  def change
    add_column :puzzles, :sent, :boolean, null: false, default: false
  end
end
