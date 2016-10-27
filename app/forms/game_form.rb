class GameForm
  include Virtus.model
  include ActiveModel::Model

  attribute :player_1, Integer
  attribute :player_2, Integer
  attribute :score_player_1, Integer
  attribute :score_player_2, Integer
  attribute :played_at, Date

  attr_accessor :game, :user_1, :user_2

  validates :score_player_1, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :score_player_2, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :played_at, presence: true
  validate :scores_validation

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

  def persist!
    persist_objects!
    EloCalc.new(user_1, user_2, elo_result)
    user_1.increment(:games_count)
    user_2.increment(:games_count)
    user_1.save!
    user_2.save!
  end

  def persist_objects!
    player_game_1 = PlayersGame.create!(player: player_1, score: score_player_1)
    player_game_2 = PlayersGame.create!(player: player_2, score: score_player_2)

    winner = [player_game_1, player_game_2].max_by(&:score)
    self.game = Game.create!(played_at: played_at, winner: winner.player)
    game.players_games << player_game_1
    game.players_games << player_game_2
    self.user_1 = player_game_1.player
    self.user_2 = player_game_2.player
  end

  def elo_result
    return EloCalc::WIN_1 if score_player_1 > score_player_2
    return EloCalc::WIN_2 if score_player_2 > score_player_1
  end

  def scores_validation
    errors.add(:scores, 'one of the scores should be greater or equal 21') unless score_player_1.to_i >= 21 || score_player_2.to_i >= 21
    errors.add(:scores, 'scores must differ 2 points at least from each other') unless (score_player_1.to_i - score_player_2.to_i).abs >= 2
  end
end
