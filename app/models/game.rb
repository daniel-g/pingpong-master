class Game < ActiveRecord::Base
  has_many :players_games
  has_many :players, through: :players_games
  belongs_to :winner, class_name: 'User'
end
