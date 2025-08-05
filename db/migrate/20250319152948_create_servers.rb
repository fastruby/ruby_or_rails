class CreateServers < ActiveRecord::Migration[8.0]
  def change
    create_table :servers do |t|
      t.string :server_id, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :servers, :server_id, unique: true
  end
end
