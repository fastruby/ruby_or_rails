class CreateAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :answers do |t|
      t.references :puzzle, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :choice
      t.boolean :is_correct

      t.timestamps
    end
  end
end
