load 'game_clock.rb'

RSpec.describe GameClock do
  describe '#initalize' do
    it "clock defaults with tick == 0" do
      clock = GameClock.new
      expect(clock.tick).to eq(0)
    end
    it "load clock with tick == 7" do
      clock = GameClock.new(7)
      expect(clock.tick).to eq(7)
    end
  end
  describe '#increment'do
    it "increment from 0 to 1" do
      clock = GameClock.new
      clock.increment
      expect(clock.tick).to eq(1)
    end
    it "increment from 7 to 8" do
      clock = GameClock.new(7)
      clock.increment
      expect(clock.tick).to eq(8)
    end
  end
  describe '#reset' do
    it 'clock after reset has tick == 0'do
      clock = GameClock.new(10)
      clock.reset
      expect(clock.tick).to eq(0)
    end
  end
  describe '#is_food_time' do
    it 'tick is greater than random_cutoff_mark, upper range 'do
      clock = GameClock.new(401)
      allow(clock).to receive(:random_cutoff_mark).and_return(400)
      expect(clock.is_food_time).to eq(true)
    end
    it 'tick is greater than random_cutoff_mark, lower range 'do
      clock = GameClock.new(301)
      allow(clock).to receive(:random_cutoff_mark).and_return(300)
      expect(clock.is_food_time).to eq(true)
    end
    it 'tick is equal to than random_cutoff_mark, upper range 'do
      clock = GameClock.new(400)
      allow(clock).to receive(:random_cutoff_mark).and_return(400)
      expect(clock.is_food_time).to eq(false)
    end
    it 'tick is lower than random_cutoff_mark, lower range 'do
      clock = GameClock.new(299)
      allow(clock).to receive(:random_cutoff_mark).and_return(300)
      expect(clock.is_food_time).to eq(false)
    end
  end
  it 'makes sure rand is called with 300..400 as range' do
    clock = GameClock.new()
    allow(clock).to receive(:rand_wrapper)
    clock.random_cutoff_mark
    expect(clock).to have_received(:rand_wrapper).with(300..400)
  end
end
