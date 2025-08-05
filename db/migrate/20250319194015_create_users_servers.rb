class CreateUsersServers < ActiveRecord::Migration[8.0]
  def change
    create_table :users_servers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :server, null: false, foreign_key: true

      t.timestamps
    end

    add_index :users_servers, [ :user_id, :server_id ], unique: true
  end
end
