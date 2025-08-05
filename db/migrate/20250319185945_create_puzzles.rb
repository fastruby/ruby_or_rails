class CreatePuzzles < ActiveRecord::Migration[8.0]
  def change
    create_table :puzzles do |t|
      t.string :question, null: false
      t.integer :answer, null: false
      t.text :explanation, null: false

      t.timestamps
    end
  end
end
