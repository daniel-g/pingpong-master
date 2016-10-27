class HomeController < ApplicationController
  def index
  end

  def history
  end

  def log
    @game_form = GameForm.new
  end
end
