class User < ActiveRecord::Base
  has_many :players_games, foreign_key: :player_id
  has_many :games, through: :players_games

  devise :database_authenticatable, :registerable, :trackable, :validatable
end
