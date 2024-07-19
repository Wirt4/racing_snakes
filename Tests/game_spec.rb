require 'rspec'
load 'game.rb'
load 'game_clock.rb'
load 'snake.rb'
load 'player_ids.rb'
load 'board.rb'

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
        snake_args << args
        double(Snake)
      end

      Game.new

      expect(snake_args[0][0]).to eq(PlayerIds::PLAYER_ONE)
      expect(snake_args[1][0]).to eq(PlayerIds::PLAYER_TWO)
    end
    it "it creates a new board object"do
      allow(Board).to receive(:new)
      Game.new()
      expect(Board).to have_received(:new)
    end
    it "gurantee the board object is called with the same colors as the snake objects"do
      snake_args = []

      allow(Snake).to receive(:new) do | *args|
        snake_args << args
        double(Snake)
      end

      allow(Board).to receive(:new)

      Game.new

      expect(Board).to have_received(:new).with(snake_args[0][1], snake_args[1][1])

  end
  end
  describe '#draw_snakes' do
    it 'calling draw_snakes causes each snake to draw'do
      game = Game.new
      allow(game.player1).to receive(:draw)
      allow(game.player2).to receive(:draw)

      game.draw_snakes

      expect(game.player1).to have_received(:draw)
      expect(game.player2).to have_received(:draw)
    end
  end
end
