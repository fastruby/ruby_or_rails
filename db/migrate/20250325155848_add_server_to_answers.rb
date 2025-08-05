class AddServerToAnswers < ActiveRecord::Migration[8.0]
  def change
    add_reference :answers, :server, null: false, foreign_key: true
  end
end
