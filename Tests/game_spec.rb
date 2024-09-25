require 'rspec'
load 'game.rb'
load 'game_clock.rb'
load 'snake.rb'
load 'player_ids.rb'
load 'board.rb'
require('ruby2d')
load 'keyboard_buttons.rb'

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

      allow(Board).to receive(:new)

      Game.new

      expect(snake_args[0][0]).to eq(PlayerIds::PLAYER_ONE)
      expect(snake_args[1][0]).to eq(PlayerIds::PLAYER_TWO)
    end
    it "it creates a new board object"do
      allow(Board).to receive(:new)
      Game.new()
      expect(Board).to have_received(:new)
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

  describe'#draw_board'do
    it'drawing the board should call draw_snakes' do
        game = Game.new
        allow(game).to receive(:draw_snakes)
        allow(game.board).to receive(:draw)

        game.draw_board

        expect(game).to have_received(:draw_snakes)
    end
    it'drawing the board should call Board.draw' do
      game = Game.new
      allow(game).to receive(:draw_snakes)
      allow(game.board).to receive(:draw)

      game.draw_board

      expect(game.board).to have_received(:draw)
    end
    it 'should call Board.snake_eat_food with player1 and player 2 as arguments'do
      game = Game.new
      allow(game).to receive(:draw_snakes)
      allow(game.board).to receive(:draw)
      board_args = []
      allow(game.board).to receive(:snake_eat_food?) do | *args|
        board_args << args
        double(game.board)
      end

      game.draw_board

      expect(board_args).to eq([[game.player1], [game.player2]])
    end
    it 'Neither snake 1 or snake 2 ate anything'do
      game = Game.new
      allow(game).to receive(:draw_snakes)
      allow(game.board).to receive(:draw)
      allow(game.board).to receive(:snake_eat_food?).and_return(false, false)
      game.draw_board

      expect(game.player1Eats).to eq(false)
      expect(game.player2Eats).to eq(false)
    end
    it 'Snake 1 ate the food'do
      game = Game.new
      allow(game).to receive(:draw_snakes)
      allow(game.board).to receive(:draw)
      allow(game.board).to receive(:snake_eat_food?).and_return(true, false)
      game.draw_board

      expect(game.player1Eats).to eq(true)
      expect(game.player2Eats).to eq(false)
    end

    it 'Snake 2 ate the food'do
      game = Game.new
      allow(game).to receive(:draw_snakes)
      allow(game.board).to receive(:draw)
      allow(game.board).to receive(:snake_eat_food?).and_return(false, true)
      game.draw_board

      expect(game.player1Eats).to eq(false)
      expect(game.player2Eats).to eq(true)
    end
  end

  describe '#is_paused'do
    it'neither Board.finished nor Board.menu is true'do
      game = Game.new
      allow(game.board).to receive(:finished?){false}
      allow(game.board).to receive (:menu?){false}

      expect(game.is_paused?).to eq(false)
    end
    it'Board.finished is true and Board.menu is false'do
      game = Game.new
      allow(game.board).to receive(:finished?){true}
      allow(game.board).to receive (:menu?){false}

      expect(game.is_paused?).to eq(true)
    end
    it'Board.finished is false and Board.menu is true'do
    game = Game.new
    allow(game.board).to receive(:finished?){false}
    allow(game.board).to receive (:menu?){true}

    expect(game.is_paused?).to eq(true)
  end
  end

  describe '#move'do
    it'should call Board.is_tie'do
      game = Game.new
      allow(game.board).to receive(:is_tie)
      game.move
      expect(game.board).to have_received(:is_tie).with(game.player1, game.player2)
    end
    it'should call move for both players'do
      game = Game.new
      allow(game.player1).to receive(:move)
      allow(game.player2).to receive(:move)

      game.move

      expect(game.player1).to have_received(:move)
      expect(game.player2).to have_received(:move)
  end
  it'should increment the clock'do
      game = Game.new
      allow(game.clock).to receive(:increment)

      game.move
      expect(game.clock).to have_received(:increment)
  end
  end

  describe '#player_eats' do
    it 'neiher player one nor player two eats anything'do
      game = Game.new
      game.player1Eats = false
      game.player2Eats = false
      expect(game.player_eats).to eq(false)
    end
    it 'player one eats something' do
      game = Game.new
      game.player1Eats = true
      game.player2Eats = false
      expect(game.player_eats).to eq(true)
    end
    it 'player two eats something' do
      game = Game.new
      game.player1Eats = false
      game.player2Eats = true
      expect(game.player_eats).to eq(true)
    end
  end
  describe'#eat_and_grow'do
    it'player1Eats is true, player one has "grow" called'do
      game = Game.new
      game.player1Eats = true
      allow(game.player1).to receive(:grow)

      game.eat_and_grow()

      expect(game.player1).to have_received(:grow)
    end
    it'player1Eats is true, player one has "grow" called'do
      game = Game.new
      game.player1Eats = false
      allow(game.player1).to receive(:grow)

      game.eat_and_grow()

      expect(game.player1).not_to have_received(:grow)
    end
    it'player2Eats is true, player two has "grow" called'do
      game = Game.new
      game.player2Eats = true
      allow(game.player2).to receive(:grow)

      game.eat_and_grow()

      expect(game.player2).to have_received(:grow)
    end
    it'player2Eats is false, player two does not "grow" called'do
      game = Game.new
      game.player2Eats = false
      allow(game.player2).to receive(:grow)

      game.eat_and_grow()

      expect(game.player2).not_to have_received(:grow)
    end
    it 'respawn food is called' do
      game = Game.new
      game.player1.position = [[0,0],[0,-1],[0,-2]]
      game.player2.position = [[1,0],[1,-1],[1,-2]]
      expected = [[0,0],[0,-1],[0,-2],[1,0],[1,-1],[1,-2]]
      allow(game.board).to receive(:respawn_food)

      game.eat_and_grow

      expect(game.board).to have_received(:respawn_food).with(expected)
    end
    it 'respawn food is called, different data' do
      game = Game.new
      game.player1.position = [[-1,0],[-1,-1],[-1,-2]]
      game.player2.position = [[1,0],[1,-1],[1,-2]]
      expected = [[-1,0],[-1,-1],[-1,-2],[1,0],[1,-1],[1,-2]]
      allow(game.board).to receive(:respawn_food)

      game.eat_and_grow

      expect(game.board).to have_received(:respawn_food).with(expected)
    end
    it 'Clock.reset is called' do
      game = Game.new
      allow(game.clock).to receive(:reset)

      game.eat_and_grow

      expect(game.clock).to have_received(:reset)
    end
  end
  describe '#is_food time'do
    it 'food time is true' do
      game = Game.new
      allow(game.clock).to receive(:is_food_time).and_return(true)
      expect(game.food_time?).to eq(true)
    end
    it 'food time is false' do
      game = Game.new
      allow(game.clock).to receive(:is_food_time).and_return(false)
      expect(game.food_time?).to eq(false)
    end
  end
  describe'#respawn_food' do
    it 'clock.reset is called'do
      game = Game.new
      allow(game.clock).to receive(:reset)

      game.respawn_food

      expect(game.clock).to have_received(:reset)
    end
    it 'board.respawn food is called'do
      game = Game.new
      allow(game.board).to receive(:respawn_food)
      game.player1.position = [[0,0],[0,-1],[0,-2]]
      game.player2.position = [[1,0],[1,-1],[1,-2]]
      expected = [[0,0],[0,-1],[0,-2],[1,0],[1,-1],[1,-2]]

      game.respawn_food

      expect(game.board).to have_received(:respawn_food).with(expected)
    end
  end
  describe'#is_collision?'do
    it'board.collision? is true'do
      game = Game.new
      allow(game.board).to receive(:collision?).and_return(true)

      expect(game.is_collision?).to eq(true)
    end
    it'board.collision? is false'do
      game = Game.new
      allow(game.board).to receive(:collision?).and_return(false)

      expect(game.is_collision?).to eq(false)
    end
    it'board.collision? is called with player positions'do
      game = Game.new
      allow(game.board).to receive(:collision?)

      game.is_collision?

      expect(game.board).to have_received(:collision?).with(game.player1.position(), game.player2.position())
    end
  end
  describe'#stop_game' do
    it'board.finish is called'do
      game = Game.new
      allow(game.board).to receive(:finish)

      game.stop_game

      expect(game.board).to have_received(:finish)
    end
    it'board.winner is called'do
      game = Game.new
      allow(game.board).to receive(:winner)

      game.stop_game

      expect(game.board).to have_received(:winner).with(game.player1, game.player2)
    end
    it'board.dropShadow is called with player 1'do
      game = Game.new
      allow(game.board).to receive(:drop_shadow)
      allow(game.board).to receive(:winner).and_return('player 1')
      game.stop_game

      expect(game.board).to have_received(:drop_shadow).with(game.board.winner, anything,  anything,)
    end

    it "player one is not the winner, and player one Z isn't set with the Z index" do
      game = Game.new
      allow(game.player1).to receive(:set_z)
      allow(game.board).to receive(:p1_winner?).and_return(false)

      game.stop_game

      expect(game.player1).not_to have_received(:set_z).with(Settings::WINNER_Z_NDX)
    end

    it "player one is  the winner, and player two Z isn't set with the Z index" do
      game = Game.new
      allow(game.player2).to receive(:set_z)
      allow(game.board).to receive(:p1_winner?).and_return(true)

      game.stop_game

      expect(game.player2).not_to have_received(:set_z).with(Settings::WINNER_Z_NDX)
    end
  end
  describe '#detect_key'do
    it 'player1.detectKey called' do
      game = Game.new
      snake_args=[]
      allow(game.player1).to receive(:detect_key) do |*args|
        snake_args << args
      end

      k = Keyboard::SPACE

      game.detect_key(k)

      expect(snake_args[0][0]).to eq(k)
    end
    it 'player1.detectKey called,  arrow down' do
      game = Game.new
      snake_args = []
      allow(game.player1).to receive(:detect_key) do |*args|
        snake_args << args
      end
      k = Keyboard::DOWN

      game.detect_key(k)

      expect(snake_args[0][0]).to eq(k)
    end
    it 'player2.detectKey called,  W' do
      game = Game.new
      snake_args =[]
      allow(game.player1).to receive(:detect_key) do |*args|
        snake_args << args
      end
      k = Keyboard::W
      allow(Board).to receive(:new)

      game.detect_key(k)

      expect(snake_args[0][0]).to eq(k)
    end
    it 'player2.detectKey called,  A' do
      game = Game.new
      snake_args =[]
      allow(game.player1).to receive(:detect_key) do |*args|
        snake_args << args
      end
      k = Keyboard::A
      allow(Board).to receive(:new)

      game.detect_key(k)

      expect(snake_args[0][0]).to eq(k)
    end
    it 'Key is space, game is finished' do
      game = Game.new
      k = Keyboard::SPACE
      allow(game.board).to receive(:finished?).and_return(true)
      allow(game).to receive(:pause)
      allow(Board).to receive(:new)
      game.detect_key(k)

      expect(Board).to have_received(:new)
    end
    it 'Key is space, game is not finished' do
      game = Game.new
      k = Keyboard::SPACE
      allow(game.board).to receive(:finished?).and_return(false)

      allow(Snake).to receive(:new)
      allow(Board).to receive(:new)

      game.detect_key(k)

      expect(Board).not_to have_received(:new)
      expect(Snake).not_to have_received(:new)
    end
    it 'Key is left, game is  finished' do
      game = Game.new
      k = Keyboard::LEFT
      allow(game.board).to receive(:finished?).and_return(true)
      allow(game).to receive(:pause)

      allow(Snake).to receive(:new)
      allow(Board).to receive(:new)

      game.detect_key(k)

      expect(Board).not_to have_received(:new)
      expect(Snake).not_to have_received(:new)
    end
    it 'Key is space, Game.pause is called' do
      game = Game.new
      k = Keyboard::SPACE

      allow(game).to receive(:pause)

      game.detect_key(k)

      expect(game).to have_received(:pause)
    end
    it 'Key is not space, Game.pause is not called' do
      game = Game.new
      k = Keyboard::A

      allow(game).to receive(:pause)

      game.detect_key(k)

      expect(game).not_to have_received(:pause)
    end
  end
  describe '#pause'do
    it 'Board pause is called' do
      game = Game.new
      allow(game.board).to receive(:pause)
      game.pause
      expect(game.board).to have_received(:pause)
    end
  end
end
