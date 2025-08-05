class AddLinkToPuzzles < ActiveRecord::Migration[8.0]
  def change
    add_column :puzzles, :link, :string
  end
end
