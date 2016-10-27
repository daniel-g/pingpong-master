class GamesDecorator
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def games
    user.games.includes(:players_games, :players).map do |game|
      GameDecorator.new(game, me: user)
    end
  end
end

class GameDecorator
  attr_reader :game, :me

  def initialize(game, me:)
    @game = game
    @me = me
  end

  def played_at
    game.played_at
  end

  def opponent
    game.players.first{|player| player != me}.email
  end

  def score
    game.players_games.map(&:score).join(' - ')
  end

  def result
    game.winner_id == me.id ? 'W' : 'L'
  end
end
