class AddStateToPuzzles < ActiveRecord::Migration[8.0]
  def change
    add_column :puzzles, :state, :integer, default: 2, null: false
  end
end
