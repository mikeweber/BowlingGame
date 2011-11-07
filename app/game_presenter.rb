require 'frame_presenter'

class GamePresenter
  def initialize(game)
    @game = game
  end
  
  def run
    last_roll = nil
    while !@game.finished?
      puts "What did you roll for the #{@game.current_frame.first_roll.nil? ? 'first' : (@game.current_frame.second_roll.nil? ? 'second' : 'third')} roll of frame #{@game.current_frame.frame}?"
      last_roll = gets.gsub("\n", '')
      break if last_roll == "exit"
      begin
        @game.roll(last_roll.to_i)
        self.print_score_card
      rescue InvalidRoll => e
        puts "You entered an invalid roll: #{last_roll}. Try again."
      end
    end
  end
  
  def print_score_card
    s  = print_top_line
    s << print_frame_numbers
    s << print_divider
    s << print_rolls
    s << print_divider
    s << print_scores
    s << print_bottom_divider
    
    puts s
  end
  
  private
  
  def print_top_line
    s  = "_" * (5 * frames_to_print)
    s << "_" * 6 if full_game?
    s << "_\n"
  end
  
  def print_frame_numbers
    s = ''
    frames.each do |frame|
      s << "|  %2d" % frame.frame
    end
    s << "|   10" if full_game?
    s << "|\n"
  end
  
  def print_divider
    s  = "|----" * frames_to_print 
    s << "|-----" if full_game?
    s << "|\n"
  end
  
  def print_rolls
    s = ''
    frames.each do |frame|
      s << FramePresenter.init(frame).print_rolls
    end
    s << FramePresenter.init(@game.frames[-1]).print_rolls if full_game?
    s << "|\n"
  end
  
  def print_scores
    s = ''
    frames.each do |frame|
      s << FramePresenter.init(frame).print_scores
    end
    s << FramePresenter.init(@game.frames[-1]).print_scores if full_game?
    s << "|\n"
  end
  
  def print_bottom_divider
    s  = "-" * (5 * frames_to_print)
    s << "-" * 7 if full_game?
    s
  end
  
  def frames
    @game.frames[0..(frames_to_print - 1)]
  end
  
  def frames_to_print
    [@game.frames.size, 9].min
  end
  
  def full_game?
    @game.frames.size == 10
  end
end
