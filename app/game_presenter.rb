require 'frame_presenter'

class GamePresenter
  def initialize(game)
    @game = game
  end
  
  def print_score_card
    s  = "_" * (5 * frames_to_print)
    s << "_" * 6 if full_game?
    s << "_\n"
    frames.each do |frame|
      s << "|  %2d" % frame.frame
    end
    s << "|   10" if full_game?
    s << "|\n"
    # s << "|----" * 9 
    # s << "|-----" if full_game?
    # s << "|\n"
    frames.each do |frame|
      s << FramePresenter.new(frame).print_rolls
    end
    s << FramePresenter.new(@game.frames[-1]).print_rolls if full_game?
    s << "|\n"
    s << "|----" * frames_to_print
    s << "|-----" if full_game?
    s << "|\n"
    frames.each do |frame|
      s << FramePresenter.new(frame).print_scores
    end
    s << FramePresenter.new(@game.frames[-1]).print_scores if full_game?
    s << "|\n"
    s << "-" * (5 * frames_to_print)
    s << "-" * 7 if full_game?
    
    puts s
  end
  
  private
  
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
