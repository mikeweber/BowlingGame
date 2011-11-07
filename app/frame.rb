class Frame
  attr_reader :frame, :last_frame
  attr_accessor :next_frame
  
  def self.init(last_frame = nil)
    if last_frame && last_frame.frame == 9
      TenthFrame.new(last_frame)
    else
      Frame.new(last_frame)
    end
  end
  
  def initialize(last_frame = nil)
    if @last_frame = last_frame
      @last_frame.next_frame = self
      @frame = last_frame.frame + 1
    else
      @frame = 1
    end
    
    @rolls = []
  end
  
  def roll(pins)
    raise CannotRollInFinishedFrame if self.finished?
    raise InvalidRoll if pins < 0 || roll_sum + pins > 10
    
    @rolls << pins
    self.finished? ? self.frame : self.frame - 1
  end
  
  def first_roll
    @rolls[0]
  end
  
  def second_roll
    @rolls[1]
  end
  
  def score
    return unless self.finished?
    
    if strike?
      return if self.next_frame.nil? || self.next_frame.next_two_rolls.nil?
      10 + self.next_frame.next_two_rolls
    elsif spare?
      return if self.next_frame.nil? || self.next_frame.first_roll.nil?
      10 + self.next_frame.first_roll
    elsif self.first_roll.nil?
      nil
    else
      roll_sum
    end
  end
  
  def total_score
    return if self.score.nil?
    
    if self.last_frame
      self.last_frame.total_score.to_i + self.score
    else
      self.score
    end
  end
  
  def next_two_rolls
    if @rolls.size == 2
      roll_sum
    elsif strike? && self.next_frame && self.next_frame.first_roll
      10 + self.next_frame.first_roll
    end
  end
  
  def open_frame?
    !(spare? || strike?)
  end
  
  def strike?
    @rolls.size == 1 && roll_sum == 10
  end
  
  def spare?
    @rolls.size == 2 && roll_sum == 10
  end
  
  def finished?
    @rolls.size == 2 || strike?
  end
  
  private
  
  def roll_sum
    @rolls.inject(0) { |sum, roll| sum + roll }
  end
end

class InvalidRoll < Exception; end
class CannotRollInFinishedFrame < Exception; end

require 'tenth_frame'
