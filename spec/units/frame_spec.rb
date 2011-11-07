APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))
$: << File.join(APP_ROOT, "app")

require 'rspec'
require 'frame'

module FrameSpecHelper
  def roll_frames(frame_count, score)
    frames = []
    frame_count.times do |i|
      frames << Frame.init(frames[i - 1])
      2.times do
        frames[-1].roll(score)
      end
    end
    
    return frames[-1]
  end
  
  def roll_spare(frame)
    frame.roll(5)
    frame.roll(5)
  end
  
  def roll_strike(frame)
    frame.roll(10)
  end
end

describe Frame do
  include FrameSpecHelper
  let(:first_frame) { Frame.init }
  
  it "should be able to roll 2 gutter balls" do
    first_frame.roll(0)
    first_frame.roll(0)
    first_frame.score.should == 0
  end
  
  it "should be able to roll 2 single hits" do
    first_frame.roll(1)
    first_frame.roll(1)
    first_frame.score.should == 2
  end
  
  it "should not be able to total larger than 10" do
    first_frame.roll(9)
    lambda { first_frame.roll(2) }.should raise_error
  end
  
  it "should not be able to roll 3 balls" do
    first_frame.roll(2)
    first_frame.roll(2)
    lambda { first_frame.roll(2) }.should raise_error
  end
  
  it "should not be able to score a spare until the next roll is finished" do
    roll_spare(first_frame)
    first_frame.score.should be_nil
  end
  
  it "should be able to score a spare when the next ball is rolled" do
    roll_spare(first_frame)
    second_frame = Frame.init(first_frame)
    second_frame.roll(2)
    first_frame.score.should == 12
  end
  
  it "should not have a score a strike until 2 balls have been rolled" do
    roll_strike(first_frame)
    first_frame.score.should be_nil
    second_frame = Frame.init(first_frame)
    second_frame.roll(2)
    first_frame.score.should be_nil
    second_frame.roll(3)
    first_frame.score.should == 15
  end
  
  it "should not be able to roll in the same frame after a strike" do
    roll_strike(first_frame)
    lambda { first_frame.roll(2) }.should raise_error
  end
  
  it "should be able to score a strike when followed by a strike" do
    roll_strike(first_frame)
    first_frame.score.should be_nil
    second_frame = Frame.init(first_frame)
    roll_strike(second_frame)
    first_frame.score.should be_nil
    third_frame = Frame.init(second_frame)
    third_frame.roll(3)
    first_frame.score.should == 23
  end
  
  context "when summing up the score to a given frame" do
    it "should show the total score" do
      first_frame.roll(3)
      first_frame.roll(4)
      first_frame.total_score.should == 7
      
      second_frame = Frame.init(first_frame)
      second_frame.roll(6)
      second_frame.roll(3)
      second_frame.score.should == 9
      second_frame.total_score.should == 16
      
      third_frame = Frame.init(second_frame)
      third_frame.roll(2)
      third_frame.roll(7)
      third_frame.score.should == 9
      third_frame.total_score.should == 25
    end
    
    it "should not show the total score when the frame was a spare and no frame follows" do
      roll_spare(first_frame)
      first_frame.total_score.should be_nil
      second_frame = Frame.init(first_frame)
      second_frame.roll(1)
      second_frame.total_score.should == 12
    end
    
    it "should not show the total score when the frame was a strike and less than 2 rolls follow" do
      roll_strike(first_frame)
      first_frame.total_score.should be_nil
      second_frame = Frame.init(first_frame)
      second_frame.roll(1)
      second_frame.roll(1)
      second_frame.total_score.should == 14
    end
    
    it "should always show the score at the end of the tenth frame after an open frame" do
      first_frame.roll(2)
      first_frame.roll(3)
      tenth_frame = TenthFrame.new(first_frame)
      tenth_frame.roll(4)
      tenth_frame.roll(5)
      tenth_frame.total_score.should == 14
    end
    
    it "should always show the score at the end of the tenth frame after a spare" do
      first_frame.roll(2)
      first_frame.roll(3)
      tenth_frame = TenthFrame.new(first_frame)
      roll_spare(tenth_frame)
      tenth_frame.total_score.should == 15
      tenth_frame.roll(5)
      tenth_frame.total_score.should == 20
    end
    
    it "should always show the score at the end of the tenth frame after a strike" do
      first_frame.roll(2)
      first_frame.roll(3)
      tenth_frame = TenthFrame.new(first_frame)
      roll_strike(tenth_frame)
      tenth_frame.total_score.should == 15
      roll_strike(tenth_frame)
      tenth_frame.total_score.should == 25
      roll_strike(tenth_frame)
      tenth_frame.total_score.should == 35
    end
  end
  
  context "when rolling the 10th frame" do
    let(:tenth_frame) {
      ninth_frame = roll_frames(9, 3)
      Frame.init(ninth_frame)
    }
    
    it "should not be able to roll a third ball after an empty frame" do
      tenth_frame.roll(2)
      tenth_frame.roll(2)
      lambda { tenth_frame.roll(2) }.should raise_error
      tenth_frame.score.should == 4
    end
    
    it "should be able to roll a third ball after a spare" do
      roll_spare(tenth_frame)
      tenth_frame.roll(5)
      tenth_frame.score.should == 15
    end
    
    it "should be able to roll a third ball after a strike" do
      roll_strike(tenth_frame)
      roll_spare(tenth_frame)
      tenth_frame.score.should == 20
    end
  end
end
