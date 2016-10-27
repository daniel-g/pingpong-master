class CreatePlayersGames < ActiveRecord::Migration
  def change
    create_table :players_games do |t|
      t.integer :player_id
      t.integer :game_id
      t.integer :score

      t.timestamps null: false
    end
  end
end
