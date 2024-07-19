require 'rspec'
load 'game.rb'
load 'game_clock.rb'
load 'snake.rb'
load 'player_ids.rb'

RSpec.describe Game do
  describe "#initialize" do
    it"it initializes a new clock object"do
      allow(GameClock).to receive(:new)
      Game.new
      expect(GameClock).to have_received(:new)
    end
    it"it initializes a new player 1 snake and new player 2 snake"do
      snake_args = []
      allow(Snake).to receive(:new) do | *args|
        snake_args<< args
        double(Snake)
      end

      Game.new

      expect(snake_args).to eq([[PlayerIds::PLAYER_ONE], [PlayerIds::PLAYER_TWO]])
    end
  end
end
