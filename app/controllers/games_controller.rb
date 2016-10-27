class GamesController < ApplicationController
  def create
    binding.pry
    @game_form = GameForm.new(
      player_1: current_user,
      player_2: player_2,
      score_player_1: game_form_params[:score_player_1],
      score_player_2: game_form_params[:score_player_2],
      played_at: game_played_at
    )
    if @game_form.save
      redirect_to '/log', notice: 'Game saved successfully'
    else
      render 'home/log'
    end
  end

  private

  def game_played_at
    @game_played_at ||= Date.new(
      game_form_params["played_at(1i)"].to_i,
      game_form_params["played_at(2i)"].to_i,
      game_form_params["played_at(3i)"].to_i
    )
  end

  def player_2
    @player_2 ||= User.find(game_form_params[:player_2])
  end

  def game_form_params
    params.require(:game_form).permit(:played_at, :player_2, :score_player_1, :score_player_2)
  end
end
