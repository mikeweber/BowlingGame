class FramePresenter
  def initialize(frame)
    @frame = frame
  end
  
  def print_rolls
    if @frame.is_a?(TenthFrame)
      if @frame.first_roll == 10
        s = "|X"
        if @frame.second_roll.nil?
          s << "| | "
        elsif @frame.second_roll == 10
          s << "|X"
          if @frame.third_roll.nil?
            s << "| "
          elsif @frame.third_roll == 10
            s << "|X"
          elsif @frame.third_roll
            s << "|#{formatted_roll(@frame.third_roll)}"
          end
        else
          s << "|#{formatted_roll(@frame.second_roll)}"
          if @frame.second_roll + @frame.third_roll == 10
            s << "|/"
          else
            s << "|#{formatted_roll(@frame.third_roll)}"
          end
        end
      elsif @frame.spare?
        s = "|#{formatted_roll(@frame.first_roll)}|/"
        if @frame.third_roll == 10
          s << "|X"
        else
          s << "|#{formatted_roll(@frame.third_roll)}"
        end
      else
        "|#{formatted_roll(@frame.first_roll)}|#{formatted_roll(@frame.second_roll)}| "
      end
    else
      if @frame.strike?
        "|  |X"
      elsif @frame.spare?
        "|#{first_roll}|/"
      else
        "|#{first_roll}|#{formatted_roll(@frame.second_roll)}"
      end
    end
  end
  
  def print_scores
    if @frame.is_a?(TenthFrame)
      if @frame.total_score
        "|  %3d" % @frame.total_score
      else
        "|     "
      end
    else
      if @frame.total_score
        "| %3d" % @frame.total_score
      else
        "|    "
      end
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
