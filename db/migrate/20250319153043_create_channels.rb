class CreateChannels < ActiveRecord::Migration[8.0]
  def change
    create_table :channels do |t|
      t.references :server, null: false, foreign_key: true
      t.string :channel_id, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
