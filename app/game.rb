require 'frame'

class Game
  attr_reader :frames
  
  def initialize
    @frames = [Frame.init]
    @frame_index = 0
  end
  
  def roll(pins)
    @frame_index = @frames[@frame_index].roll(pins)
    @frames[@frame_index] ||= Frame.init(previous_frame)
  end
  
  def score
    @frames.inject(0) { |score, frame| score + frame.score.to_i}
  end
  
  def finished?
    self.current_frame.is_a?(TenthFrame) && @frames[-1].finished?
  end
  
  def current_frame
    @frames[-1]
  end
  
  private
  
  def previous_frame
    @frames[@frame_index - 1] unless @frame_index == 0
  end
end
