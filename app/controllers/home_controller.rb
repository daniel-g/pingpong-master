class HomeController < ApplicationController
  def index
  end

  def history
    @games = current_user.games.includes(:players_games)
  end

  def log
    @game_form = GameForm.new
  end
end
