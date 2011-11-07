class TenthFramePresenter < FramePresenter
  def print_rolls
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
  end
  
  def print_scores
    if @frame.total_score
      "|  %3d" % @frame.total_score
    else
      "|     "
    end
  end
end