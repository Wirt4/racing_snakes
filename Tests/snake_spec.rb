load 'snake.rb'
load 'player_ids.rb'
load 'directions.rb'
require 'ruby2d'

RSpec.describe Snake do
  describe '#initialize' do
    it 'passing a player one id to Snake gets it passed to Button' do
      allow(Button).to receive(:new)
      Snake.new(PlayerIds::PLAYER_ONE)
      expect(Button).to have_received(:new).with(PlayerIds::PLAYER_ONE)
    end
    it 'passing a player two id to Snake gets it passed to Button' do
      allow(Button).to receive(:new)
      Snake.new(PlayerIds::PLAYER_TWO)
      expect(Button).to have_received(:new).with(PlayerIds::PLAYER_TWO)
    end
    it 'making sure the color is set with the results from sampling the settings'do
      allow(Settings::PLAYER_TWO_COLORS).to receive(:sample).and_return('blue')
      snake = Snake.new(PlayerIds::PLAYER_TWO)
      expect(snake.color_name).to eq('Blue')
    end
    it 'making sure the color is set with the results from sampling the settings'do
      allow(Settings::PLAYER_TWO_COLORS).to receive(:sample).and_return('red')
      snake = Snake.new(PlayerIds::PLAYER_TWO)
      expect(snake.color_name).to eq('Red')
    end
    it 'making sure the color is set with the results from sampling the settings'do
      allow(Settings::PLAYER_TWO_COLORS).to receive(:sample).and_return('blue')
      snake = Snake.new(PlayerIds::PLAYER_TWO)
      expect(snake.color_name).to eq('Blue')
    end
    it 'making sure the color is set with the results from sampling the settings'do
      allow(Settings::PLAYER_ONE_COLORS).to receive(:sample).and_return('red')
      snake = Snake.new(PlayerIds::PLAYER_ONE)
      expect(snake.color_name).to eq('Red')
    end
    it'position is set for snake 1'do
      snake = Snake.new(PlayerIds::PLAYER_ONE)
      xpos = Settings::GRID_WIDTH * 2 / 3
      expected = [[xpos, Settings::GRID_HEIGHT - 3], [xpos, Settings::GRID_HEIGHT - 4], [xpos, Settings::GRID_HEIGHT - 5]]
      expect(snake.position).to eq(expected)
    end
    it'position is set for snake 2'do
      snake = Snake.new(PlayerIds::PLAYER_TWO)
      xpos = Settings::GRID_WIDTH / 3
      expected = [[xpos, Settings::GRID_HEIGHT - 3], [xpos, Settings::GRID_HEIGHT - 4], [xpos, Settings::GRID_HEIGHT - 5]]
      expect(snake.position).to eq(expected)
    end
    it 'direction is initialized as up' do
      snake = Snake.new(PlayerIds::PLAYER_TWO,)
      expect(snake.direction).to eq(Directions::UP)
    end
    it 'turned is initialized as false'do
      snake = Snake.new(PlayerIds::PLAYER_TWO)
      expect(snake.turned).to eq(false)
    end
    it 'growing is initialized as false'do
      snake = Snake.new(PlayerIds::PLAYER_TWO)
      expect(snake.growing).to eq(false)
    end
    it 'z index intialized as 0'do
      snake = Snake.new(PlayerIds::PLAYER_TWO)
      expect(snake.z).to eq(0)
    end
    it 'test color getter'do
      allow(Settings::PLAYER_TWO_COLORS).to receive(:sample).and_return('blue')
      snake = Snake.new(PlayerIds::PLAYER_TWO)
      expect(snake.color).to eq('blue')
    end
    it 'test color getter, yellow'do
    allow(Settings::PLAYER_TWO_COLORS).to receive(:sample).and_return('yellow')
    snake = Snake.new(PlayerIds::PLAYER_TWO)
    expect(snake.color).to eq('yellow')
  end
  end
  describe 'hit_wall?'do
    it 'make sure the body has been called' do
      snake_1 = Snake.new(PlayerIds::PLAYER_ONE)
      snake_2 = Snake.new(PlayerIds::PLAYER_TWO)
      allow(snake_1).to receive(:body).and_call_original
      snake_1.hit_wall?(snake_2)
      expect(snake_1).to have_received(:body)
    end
    it 'make sure position is now equal to the result of body + otherplayer.head' do
      snake_1 = Snake.new(PlayerIds::PLAYER_ONE)
      snake_2 = Snake.new(PlayerIds::PLAYER_TWO)
      xpos = Settings::GRID_WIDTH * 2 / 3
      allow(snake_1).to receive(:body).and_return([[xpos, Settings::GRID_HEIGHT - 3], [xpos, Settings::GRID_HEIGHT - 4]])
      allow(snake_2).to receive(:head).and_return([1,1])
      snake_1.hit_wall?(snake_2)
      expect(snake_1.position).to eq(snake_1.body + [snake_2.head])
    end
    it 'confirm crash has been called' do
      snake_1 = Snake.new(PlayerIds::PLAYER_ONE)
      snake_2 = Snake.new(PlayerIds::PLAYER_TWO)
      allow(snake_1).to receive(:crash?)
      snake_1.hit_wall?(snake_2)
      expect(snake_1).to have_received(:crash?)
    end
    it 'crash is true' do
      snake_1 = Snake.new(PlayerIds::PLAYER_ONE)
      snake_2 = Snake.new(PlayerIds::PLAYER_TWO)
      allow(snake_1).to receive(:crash?).and_return(true)
      expect(snake_1.hit_wall?(snake_2)).to eq(true)
    end
    it 'crash is false' do
      snake_1 = Snake.new(PlayerIds::PLAYER_ONE)
      snake_2 = Snake.new(PlayerIds::PLAYER_TWO)
      allow(snake_1).to receive(:crash?).and_return(false)
      expect(snake_1.hit_wall?(snake_2)).to eq(false)
    end
  end
  describe ('draw')do
    it 'draw_base is called 3 times'do
      snake = Snake.new(PlayerIds::PLAYER_ONE)
      call_count =0
      allow(snake).to receive(:draw_base) do | arg|
        call_count +=1
      end

      snake.draw
      expect(call_count).to eq(3)
    end
    it 'draw_base is called 5 times'do
        snake = Snake.new(PlayerIds::PLAYER_ONE)
        snake.position = [[0,1],[0,2],[0,3],[0,4],[0,5]]
        call_count =0
      allow(snake).to receive(:draw_base) do | arg|
        call_count +=1
      end
      snake.draw
      expect(call_count).to eq(5)
    end
    it 'draw_base is called with the position'do
        snake = Snake.new(PlayerIds::PLAYER_ONE)
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
      snake = Snake.new(PlayerIds::PLAYER_ONE,)
      allow(Square).to receive(:new)
      snake.draw_base([0,0])
      expect(Square).to have_received(:new)
    end
    it 'expect Square to be called with specific coordinates' do
      allow(Settings::PLAYER_ONE_COLORS).to receive(:sample).and_return('red')
      snake = Snake.new(PlayerIds::PLAYER_ONE)
      allow(Square).to receive(:new)
      snake.draw_base([0,0])
      expect(Square).to have_received(:new).with(x:0, y: 0, size: Settings::NODE_SIZE, color: "red", z: 0)
    end
    it 'expect Square to be called with different arguments' do
      allow(Settings::PLAYER_ONE_COLORS).to receive(:sample).and_return('yellow')
      snake = Snake.new(PlayerIds::PLAYER_ONE)
      allow(Square).to receive(:new)
      snake.draw_base([1,1])
      expect(Square).to have_received(:new).with(x:Settings::GRID_SIZE, y: Settings::GRID_SIZE, size: Settings::NODE_SIZE, color: "yellow", z: 0)
    end
    it 'expect Square to be called with different arguments' do
      allow(Settings::PLAYER_TWO_COLORS).to receive(:sample).and_return('green')
      snake = Snake.new(PlayerIds::PLAYER_TWO)
      allow(Square).to receive(:new)
      snake.draw_base([3,5])
      expect(Square).to have_received(:new).with(x: 3* Settings::GRID_SIZE, y: 5*Settings::GRID_SIZE, size: Settings::NODE_SIZE, color: "green", z: 0)
    end
  end
  describe 'new_direction tests'do
    it 'dir is set, right'do
      snake = Snake.new()
      snake.new_direction(Directions::RIGHT)
      expect(snake.direction).to eq (Directions::RIGHT)
    end
    it 'dir is set, down'do
      snake = Snake.new()
      snake.new_direction(Directions::DOWN)
      expect(snake.direction).to eq (Directions::DOWN)
    end
    it 'turned is true, new direction is down' do
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
  describe 'detect_key' do
    describe 'player one'do
      describe 'anticlockwise'do
        it 'turn right to up' do
          snake = Snake.new()
          snake.direction = Directions::RIGHT
          allow(snake).to receive(:set_allowable_direction)
          snake.detect_key('up')
          expect(snake).to have_received(:set_allowable_direction).with (Directions::UP)
        end
        it 'turn up to left' do
          snake = Snake.new()
          snake.direction = Directions::UP
          allow(snake).to receive(:set_allowable_direction)
          snake.detect_key('left')
          expect(snake).to have_received(:set_allowable_direction).with (Directions::LEFT)
        end
        it 'turn left to down' do
          snake = Snake.new()
          snake.direction = Directions::LEFT
          allow(snake).to receive(:set_allowable_direction)
          snake.detect_key('down')
          expect(snake).to have_received(:set_allowable_direction).with (Directions::DOWN)
        end
        it 'turn down to right' do
          snake = Snake.new()
          snake.direction = Directions::DOWN
          allow(snake).to receive(:set_allowable_direction)
          snake.detect_key('right')
          expect(snake).to have_received(:set_allowable_direction).with (Directions::RIGHT)
        end
      end
      describe'clockwise'do
      it 'sweep against direction right' do
        snake = Snake.new()
        snake.direction = Directions::RIGHT
        allow(snake).to receive(:set_allowable_direction)
        snake.detect_key('down')
        expect(snake).to have_received(:set_allowable_direction).with (Directions::DOWN)
      end
      it 'sweep against direction up' do
        snake = Snake.new()
        snake.direction = Directions::UP
        allow(snake).to receive(:set_allowable_direction)
        snake.detect_key('right')
        expect(snake).to have_received(:set_allowable_direction).with (Directions::RIGHT)
      end
      it 'sweep against direction left' do
        snake = Snake.new()
        snake.direction = Directions::LEFT
        allow(snake).to receive(:set_allowable_direction)
        snake.detect_key('up')
        expect(snake).to have_received(:set_allowable_direction).with (Directions::UP)
      end
      end
    end
    describe 'player two'do
      describe 'anticlockwise'do
        it 'right to up' do
          snake = Snake.new(PlayerIds::PLAYER_TWO)
          snake.direction = Directions::RIGHT
          allow(snake).to receive(:set_allowable_direction)
          snake.detect_key('w')
          expect(snake).to have_received(:set_allowable_direction).with (Directions::UP)
        end
        it 'up to left' do
          snake = Snake.new(PlayerIds::PLAYER_TWO)
          snake.direction = Directions::UP
          allow(snake).to receive(:set_allowable_direction)
          snake.detect_key('a')
          expect(snake).to have_received(:set_allowable_direction).with (Directions::LEFT)
        end
        it 'left to down' do
          snake = Snake.new(PlayerIds::PLAYER_TWO)
          snake.direction = Directions::LEFT
          allow(snake).to receive(:set_allowable_direction)
          snake.detect_key('s')
          expect(snake).to have_received(:set_allowable_direction).with (Directions::DOWN)
        end
        it 'down to right' do
          snake = Snake.new(PlayerIds::PLAYER_TWO)
          snake.direction = Directions::DOWN
          allow(snake).to receive(:set_allowable_direction)
          snake.detect_key('d')
          expect(snake).to have_received(:set_allowable_direction).with (Directions::RIGHT)
        end
      end
      describe'clockwise'do
      it 'right to down' do
        snake = Snake.new(PlayerIds::PLAYER_TWO)
        snake.direction = Directions::RIGHT
        allow(snake).to receive(:set_allowable_direction)
        snake.detect_key('s')
        expect(snake).to have_received(:set_allowable_direction).with (Directions::DOWN)
      end
      it 'up to right' do
        snake = Snake.new(PlayerIds::PLAYER_TWO)
        snake.direction = Directions::UP
        allow(snake).to receive(:set_allowable_direction)
        snake.detect_key('d')
        expect(snake).to have_received(:set_allowable_direction).with (Directions::RIGHT)
      end
      it 'left to up' do
        snake = Snake.new(PlayerIds::PLAYER_TWO)
        snake.direction = Directions::LEFT
        allow(snake).to receive(:set_allowable_direction)
        snake.detect_key('w')
        expect(snake).to have_received(:set_allowable_direction).with (Directions::UP)
      end
      end
    end
  end
  describe('move tests')do
    it 'snake is not growing, expect shift to be called on position' do
      snake = Snake.new()
      allow(snake.position).to receive(:shift)
      snake.growing = false
      snake.move
      expect(snake.position).to have_received(:shift)
    end
    it 'snake is  growing, expect shift ot to be called on position' do
      snake = Snake.new()
      allow(snake.position).to receive(:shift)
      snake.growing = true
      snake.move
      expect(snake.position).not_to have_received(:shift)
    end
    it 'snake is moving up and' do
      snake = Snake.new()
      allow(snake).to receive(:push_adjusted)
      snake.growing = false
      snake.move
      expect(snake).to have_received(:push_adjusted)
    end
    it 'snake is moving up and growing' do
      snake = Snake.new()
      allow(snake).to receive(:push_adjusted)
      snake.growing = true
      snake.move
      expect(snake).to have_received(:push_adjusted)
    end
    it 'snake is moving up with arguments' do
      snake = Snake.new()
      allow(snake).to receive(:push_adjusted)
      snake.direction = Directions::UP

      snake.move
      expect(snake).to have_received(:push_adjusted).with(snake.head[0], snake.head[1] - 1)
    end
    it 'snake is moving right with arguments' do
      snake = Snake.new()
      allow(snake).to receive(:push_adjusted)
      snake.direction = Directions::RIGHT
      snake.move
      expect(snake).to have_received(:push_adjusted).with(snake.head[0] + 1, snake.head[1])
    end
    it 'snake is moving down with arguments' do
      snake = Snake.new()
      allow(snake).to receive(:push_adjusted)
      snake.direction = Directions::DOWN
      snake.move
      expect(snake).to have_received(:push_adjusted).with(snake.head[0], snake.head[1] + 1)
    end
    it 'snake is moving left with arguments' do
      snake = Snake.new()
      allow(snake).to receive(:push_adjusted)
      snake.direction = Directions::LEFT
      snake.move
      expect(snake).to have_received(:push_adjusted).with(snake.head[0]-1, snake.head[1])
    end
    it 'growing is false' do
      snake = Snake.new()
      snake.move
      expect(snake.growing).to eq(false)
    end
    it 'turned is false' do
      snake = Snake.new()
      snake.move
      expect(snake.turned).to eq(false)
    end
  end
  describe 'push_adjusted tests'do
    it 'expect legal coordinates to be pushed to position' do
      snake = Snake.new()
      allow(snake.position).to receive(:push)
      snake.push_adjusted(0,0)
      expect(snake.position).to have_received(:push).with ([0,0])
    end
    it 'expect other legal coordinates to be pushed to position' do
      snake = Snake.new()
      allow(snake.position).to receive(:push)
      snake.push_adjusted(4,5)
      expect(snake.position).to have_received(:push).with ([4,5])
    end
    it 'expect other legal coordinates to be pushed to position' do
      snake = Snake.new()
      allow(snake.position).to receive(:push)
      snake.push_adjusted(4,5)
      expect(snake.position).to have_received(:push).with ([4,5])
    end
    it 'expect lateral wraparound positive' do
      snake = Snake.new()
      allow(snake.position).to receive(:push)
      snake.push_adjusted(Settings::GRID_WIDTH,5)
      expect(snake.position).to have_received(:push).with ([0,5])
    end
    it 'expect lateral wraparound negative' do
      snake = Snake.new()
      allow(snake.position).to receive(:push)
      snake.push_adjusted(-1,5)
      expect(snake.position).to have_received(:push).with([Settings::GRID_WIDTH - 1, 5])
    end
    it 'expect vertical wraparound positive' do
      snake = Snake.new()
      allow(snake.position).to receive(:push)
      snake.push_adjusted(0,Settings::GRID_HEIGHT)
      expect(snake.position).to have_received(:push).with ([0,0])
    end
    it 'expect vertical wraparound negative' do
      snake = Snake.new()
      allow(snake.position).to receive(:push)
      snake.push_adjusted(0,-1)
      expect(snake.position).to have_received(:push).with ([0,Settings::GRID_HEIGHT - 1])
    end
  end
end
