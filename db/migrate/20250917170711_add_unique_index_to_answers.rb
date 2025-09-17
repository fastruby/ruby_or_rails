class AddUniqueIndexToAnswers < ActiveRecord::Migration[8.0]
  def change
    add_index :answers, [ :puzzle_id, :user_id, :server_id ], unique: true, name: 'index_answers_on_puzzle_user_server'
  end
end
