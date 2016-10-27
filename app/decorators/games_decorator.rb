class GamesDecorator
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def games
    user.games.includes(:players_games, :players).order('games.played_at DESC').map do |game|
      GameDecorator.new(game, me: user)
    end
  end

  class GameDecorator
    attr_reader :game, :me

    def initialize(game, me:)
      @game = game
      @me = me
    end

    def played_at
      game.played_at.strftime('%b %d, %Y')
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
end
