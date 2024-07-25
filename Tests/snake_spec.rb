load 'snake.rb'
load 'player_ids.rb'
load 'directions.rb'

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
end
