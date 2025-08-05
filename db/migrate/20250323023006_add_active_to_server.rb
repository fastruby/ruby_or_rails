class AddActiveToServer < ActiveRecord::Migration[8.0]
  def change
    add_column :servers, :active, :boolean, default: true
  end
end
