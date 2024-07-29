load 'snake.rb'
load 'player_ids.rb'
load 'directions.rb'
require 'ruby2d'

RSpec.describe Snake do
  describe '#initialize' do
    it 'passing a player one id to Snake gets it passed to Button' do
      allow(Button).to receive(:new)
      Snake.new(PlayerIds::PLAYER_ONE, "red")
      expect(Button).to have_received(:new).with(PlayerIds::PLAYER_ONE)
    end
    it 'passing a player two id to Snake gets it passed to Button' do
      allow(Button).to receive(:new)
      Snake.new(PlayerIds::PLAYER_TWO, "red")
      expect(Button).to have_received(:new).with(PlayerIds::PLAYER_TWO)
    end
    it 'passing a color to the snake sets it'do
      snake = Snake.new(PlayerIds::PLAYER_TWO, "red")
      expect(snake.color_name).to eq('Red')
    end
    it 'passing a color to the snake sets it'do
      snake = Snake.new(PlayerIds::PLAYER_TWO, "blue")
      expect(snake.color_name).to eq('Blue')
    end
    it'position is set for snake 1'do
      snake = Snake.new(PlayerIds::PLAYER_ONE, "red")
      xpos = Settings::GRID_WIDTH * 2 / 3
      expected = [[xpos, Settings::GRID_HEIGHT - 3], [xpos, Settings::GRID_HEIGHT - 4], [xpos, Settings::GRID_HEIGHT - 5]]
      expect(snake.position).to eq(expected)
    end
    it'position is set for snake 2'do
      snake = Snake.new(PlayerIds::PLAYER_TWO, "red")
      xpos = Settings::GRID_WIDTH / 3
      expected = [[xpos, Settings::GRID_HEIGHT - 3], [xpos, Settings::GRID_HEIGHT - 4], [xpos, Settings::GRID_HEIGHT - 5]]
      expect(snake.position).to eq(expected)
    end
    it 'direction is initialized as up' do
      snake = Snake.new(PlayerIds::PLAYER_TWO, "red")
      expect(snake.direction).to eq(Directions::UP)
    end
    it 'turned is initialized as false'do
      snake = Snake.new(PlayerIds::PLAYER_TWO, "red")
      expect(snake.turned).to eq(false)
    end
    it 'growing is initialized as false'do
      snake = Snake.new(PlayerIds::PLAYER_TWO, "red")
      expect(snake.growing).to eq(false)
    end
    it 'z index intialized as 0'do
      snake = Snake.new(PlayerIds::PLAYER_TWO, "red")
      expect(snake.z).to eq(0)
    end
  end
  describe 'hit_wall?'do
    it 'make sure the body has been called' do
      snake_1 = Snake.new(PlayerIds::PLAYER_ONE, "red")
      snake_2 = Snake.new(PlayerIds::PLAYER_TWO, "blue")
      allow(snake_1).to receive(:body).and_call_original
      snake_1.hit_wall?(snake_2)
      expect(snake_1).to have_received(:body)
    end
    it 'make sure position is now equal to the result of body + otherplayer.head' do
      snake_1 = Snake.new(PlayerIds::PLAYER_ONE, "red")
      snake_2 = Snake.new(PlayerIds::PLAYER_TWO, "blue")
      xpos = Settings::GRID_WIDTH * 2 / 3
      allow(snake_1).to receive(:body).and_return([[xpos, Settings::GRID_HEIGHT - 3], [xpos, Settings::GRID_HEIGHT - 4]])
      allow(snake_2).to receive(:head).and_return([1,1])
      snake_1.hit_wall?(snake_2)
      expect(snake_1.position).to eq(snake_1.body + [snake_2.head])
    end
    it 'confirm crash has been called' do
      snake_1 = Snake.new(PlayerIds::PLAYER_ONE, "red")
      snake_2 = Snake.new(PlayerIds::PLAYER_TWO, "blue")
      allow(snake_1).to receive(:crash?)
      snake_1.hit_wall?(snake_2)
      expect(snake_1).to have_received(:crash?)
    end
    it 'crash is true' do
      snake_1 = Snake.new(PlayerIds::PLAYER_ONE, "red")
      snake_2 = Snake.new(PlayerIds::PLAYER_TWO, "blue")
      allow(snake_1).to receive(:crash?).and_return(true)
      expect(snake_1.hit_wall?(snake_2)).to eq(true)
    end
    it 'crash is false' do
      snake_1 = Snake.new(PlayerIds::PLAYER_ONE, "red")
      snake_2 = Snake.new(PlayerIds::PLAYER_TWO, "blue")
      allow(snake_1).to receive(:crash?).and_return(false)
      expect(snake_1.hit_wall?(snake_2)).to eq(false)
    end
  end
  describe ('draw')do
    it 'draw_base is called 3 times'do
      snake = Snake.new(PlayerIds::PLAYER_ONE, "red")
      call_count =0
      allow(snake).to receive(:draw_base) do | arg|
        call_count +=1
      end

      snake.draw
      expect(call_count).to eq(3)
    end
    it 'draw_base is called 5 times'do
        snake = Snake.new(PlayerIds::PLAYER_ONE, "red")
        snake.position = [[0,1],[0,2],[0,3],[0,4],[0,5]]
        call_count =0
      allow(snake).to receive(:draw_base) do | arg|
        call_count +=1
      end
      snake.draw
      expect(call_count).to eq(5)
    end
    it 'draw_base is called with the position'do
        snake = Snake.new(PlayerIds::PLAYER_ONE, "red")
        snake.position = [[0,1],[0,2],[0,3],[0,4],[0,5]]
        pos_args = []
      allow(snake).to receive(:draw_base) do | *args|
        pos_args << args
      end
      snake.draw
      expect(pos_args).to eq([[[0,1]],[[0,2]],[[0,3]],[[0,4]],[[0,5]]])
    end
  end
  describe 'draw_base tests'do
    it 'expect Square to be called' do
      snake = Snake.new(PlayerIds::PLAYER_ONE, "red")
      allow(Square).to receive(:new)
      snake.draw_base([0,0])
      expect(Square).to have_received(:new)
    end
    it 'expect Square to be called with specific coordinates' do
      snake = Snake.new(PlayerIds::PLAYER_ONE, "red")
      allow(Square).to receive(:new)
      snake.draw_base([0,0])
      expect(Square).to have_received(:new).with(x:0, y: 0, size: Settings::NODE_SIZE, color: "red", z: 0)
    end
    it 'expect Square to be called with different arguments' do
      snake = Snake.new(PlayerIds::PLAYER_ONE, "yellow")
      allow(Square).to receive(:new)
      snake.draw_base([1,1])
      expect(Square).to have_received(:new).with(x:Settings::GRID_SIZE, y: Settings::GRID_SIZE, size: Settings::NODE_SIZE, color: "yellow", z: 0)
    end
    it 'expect Square to be called with different arguments' do
      snake = Snake.new(PlayerIds::PLAYER_TWO, "green")
      allow(Square).to receive(:new)
      snake.draw_base([3,5])
      expect(Square).to have_received(:new).with(x: 3* Settings::GRID_SIZE, y: 5*Settings::GRID_SIZE, size: Settings::NODE_SIZE, color: "green", z: 0)
    end
  end
  describe 'new_direction tests'do
    it 'dir is set'do
      snake = Snake.new()
      snake.new_direction(Directions::RIGHT)
      expect(snake.direction).to eq (Directions::RIGHT)
    end
    it 'dir is set'do
      snake = Snake.new()
      snake.new_direction(Directions::DOWN)
      expect(snake.direction).to eq (Directions::DOWN)
    end
    it 'turned is true' do
      snake = Snake.new()
      snake.direction = Directions::RIGHT
      snake.turned = true

      snake.new_direction(Directions::DOWN)
      expect(snake.direction).to eq (Directions::RIGHT)
    end
    it 'turned is true after execution' do
      snake = Snake.new()
      snake.turned = false

      snake.new_direction(Directions::DOWN)
      expect(snake.turned).to eq (true)
    end
  end
end
