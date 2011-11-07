class TenthFrame < Frame
  def roll(pins)
    raise Exception if finished?
    @rolls << pins
    
    return 9
  end
  
  def score
    roll_sum if self.finished?
  end
  
  def spare?
    @rolls[0].to_i + @rolls[1].to_i == 10
  end
  
  def third_roll
    @rolls[2]
  end
  
  def next_two_rolls
    return unless @rolls.size >= 2
    
    @rolls[0] + @rolls[1]
  end
  
  def finished?
    @rolls.size == 3 || @rolls.size == 2 && roll_sum < 10
  end
end
