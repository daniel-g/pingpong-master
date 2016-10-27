require 'rails_helper'
require 'ostruct'

describe GameForm do
  let(:valid_attributes) do {
    player_1: player_1,
    player_2: player_2,
    score_player_1: 21,
    score_player_2: 19,
    played_at: Time.now
  } end

  let(:player_1) { FactoryGirl.create(:user) }
  let(:player_2) { FactoryGirl.create(:user) }

  it 'saves a game' do
    game_form = GameForm.new(valid_attributes)
    expect(game_form.save).to be_truthy
  end

  it 'saves game players' do
    game_form = GameForm.new(valid_attributes)
    game_form.save
    game = game_form.game
    expect(game.players.count).to eq 2
    expect(game.players).to match_array([player_1, player_2])
  end

  it 'validates played at date is present' do
    game_form = GameForm.new(player_1: player_1, player_2: player_2, score_player_1: 21, score_player_2: 19)
    expect(game_form).to_not be_valid
    game_form.played_at = Time.now
    expect(game_form).to be_valid
  end

  it 'validates score of player 1 is a number' do
    game_form = GameForm.new(player_1: player_1, player_2: player_2, score_player_1: 'ab', score_player_2: 19, played_at: Time.now)
    expect(game_form).to_not be_valid
    game_form.score_player_1 = 21
    expect(game_form).to be_valid
  end

  it 'validates score of player 2 is a number' do
    game_form = GameForm.new(player_1: player_1, player_2: player_2, score_player_1: 21, score_player_2: 'ab', played_at: Time.now)
    expect(game_form).to_not be_valid
    game_form.score_player_2 = 19
    expect(game_form).to be_valid
  end

  it 'validates scores have 2 points of difference and the winner has 21 points or more' do
    game_form = GameForm.new(player_1: player_1, player_2: player_2, score_player_1: 21, score_player_2: 20, played_at: Time.now)
    expect(game_form).to_not be_valid
    game_form.score_player_1 = 18
    expect(game_form).to_not be_valid
    game_form.score_player_1 = 21
    game_form.score_player_2 = 19
    expect(game_form).to be_valid
  end

  it 'saves the winner in the game' do
    game_form = GameForm.new(valid_attributes)
    game_form.save
    game = game_form.game
    expect(game.winner).to eq player_1
  end

  it 'saves new scores to players' do
    player_1.update_attribute(:rating, 100)
    player_2.update_attribute(:rating, 300)
    player_1_elo = OpenStruct.new(rating: 100)
    player_2_elo = OpenStruct.new(rating: 300)
    EloCalc.new(player_1_elo, player_2_elo, EloCalc::WIN_1)
    game_form = GameForm.new(valid_attributes)
    game_form.save
    expect(player_1.rating).to eq player_1_elo.rating
    expect(player_2.rating).to eq player_2_elo.rating
  end

  it 'increments games played to players' do
    game_form = GameForm.new(valid_attributes)
    game_form.save
    expect(player_1.games_count).to eq 1
    expect(player_2.games_count).to eq 1
    game_form = GameForm.new(valid_attributes)
    game_form.save
    expect(player_1.games_count).to eq 2
    expect(player_2.games_count).to eq 2
  end
end
