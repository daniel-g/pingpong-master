class HomeController < ApplicationController
  def index
    @users = User.order('rating DESC')
  end

  def history
    @games = GamesDecorator.new(current_user).games
  end

  def log
    @game_form = GameForm.new
  end
end
