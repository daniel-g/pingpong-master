class HomeController < ApplicationController
  def index
    @users = User.select('row_number() OVER(ORDER BY rating DESC) as rank, users.*').order('rating DESC')
  end

  def history
    @games = GamesDecorator.new(current_user).games
  end

  def log
    @opponents =  User.where.not(id: current_user).collect {|u| [ u.email, u.id ] }
    @game_form = GameForm.new
  end
end
