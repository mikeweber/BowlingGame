require 'game'
require 'game_presenter'

def run
  game = Game.new
  
  last_roll = nil
  while !game.finished?
    puts "What did you roll for the #{game.current_frame.first_roll.nil? ? 'first' : (game.current_frame.second_roll.nil? ? 'second' : 'third')} roll of frame #{game.current_frame.frame}?"
    last_roll = gets.gsub("\n", '')
    break if last_roll == "exit"
    begin
      game.roll(last_roll.to_i)
      GamePresenter.new(game).print_score_card
    rescue InvalidRoll => e
      puts "You entered an invalid roll: #{last_roll}. Try again."
    end
  end
end
