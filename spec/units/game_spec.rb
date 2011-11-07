APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))
$: << File.join(APP_ROOT, "app")

require 'rspec'
require 'game'

module GameSpecHelper
  def roll_frames(frames, score)
    frames.times do
      game.roll(score)
    end
  end
  
  def roll_spare
    roll_frames(2, 5)
  end
  
  def roll_strike
    game.roll(10)
  end
end

describe Game do
  include GameSpecHelper
  let(:game) { Game.new }
  
  it "should be able to roll a gutter game" do
    roll_frames(20, 0)
    
    game.score.should == 0
  end
  
  it "should be able to roll all 1s" do
    roll_frames(20, 1)
    
    game.score.should == 20
  end
  
  it "should be able score a spare" do
    roll_spare
    game.roll(1)
    roll_frames(17, 0)
    
    game.score.should == 12
  end
  
  it "should be able to score a strike" do
    roll_strike
    game.roll(2)
    game.roll(3)
    roll_frames(16, 0)
    
    game.score.should == 20
  end
  
  it "should be able to score a perfect game" do
    roll_frames(12, 10)
    
    game.score.should == 300
  end
end
