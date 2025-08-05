class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :user_id, null: false
      t.string :username, null: false
      t.integer :role, null: false, default: 1 # Default role is "member"

      t.timestamps
    end

    add_index :users, :user_id, unique: true
  end
end
