class FramePresenter
  def self.init(frame)
    if frame.is_a?(TenthFrame)
      TenthFramePresenter.new(frame)
    else
      FramePresenter.new(frame)
    end
  end
  
  def initialize(frame)
    @frame = frame
  end
  
  def print_rolls
    if @frame.strike?
      "|  |X"
    elsif @frame.spare?
      "|#{first_roll}|/"
    else
      "|#{first_roll}|#{formatted_roll(@frame.second_roll)}"
    end
  end
  
  def print_scores
    if @frame.total_score
      "| %3d" % @frame.total_score
    else
      "|    "
    end
  end
  
  private
  
  def first_roll
    if @frame.first_roll
      "%2d" % @frame.first_roll
    else
      "  "
    end
  end
  
  def formatted_roll(score)
    score || " "
  end
end

require 'tenth_frame_presenter'
