class AddGamesCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :games_count, :integer
  end
end
