require 'rspec'
load 'board.rb'
load 'snake.rb'

RSpec.describe Board do
  describe '#initialize' do
    it "food's x coordinate should be halfway across the board" do
      stub_const('Settings::GRID_WIDTH', 10)
      s1 = Snake.new()
      s2 = Snake.new()
      board = Board.new(s1, s2)
      expect(board.food_x).to eq(5)
    end
    it "food's x coordinate should be halfway across the board" do
      stub_const('Settings::GRID_WIDTH', 20)
      s1 = Snake.new()
      s2 = Snake.new()
      board = Board.new(s1, s2)
      expect(board.food_x).to eq(10)
    end
    it "food's x coordinate should be halfway across the board" do
      stub_const('Settings::GRID_HEIGHT', 21)
      s1 = Snake.new()
      s2 = Snake.new()
      board = Board.new(s1, s2)
      expect(board.food_y).to eq(7)
    end
    it "food's x coordinate should be halfway across the board" do
      stub_const('Settings::GRID_HEIGHT', 10)
      s1 = Snake.new()
      s2 = Snake.new()
      board = Board.new(s1, s2)
      expect(board.food_y).to eq(3)
    end
    it "board should initialize with finished as false" do
      s1 = Snake.new()
      s2 = Snake.new()
      board = Board.new(s1, s2)
      expect(board.finished?).to eq(false)
    end
    it "board should initialize with paused as true" do
      s1 = Snake.new()
      s2 = Snake.new()
      board = Board.new(s1, s2)
      expect(board.menu?).to eq(true)
    end
    it "board should initialize with tie as false" do
      s1 = Snake.new()
      s2 = Snake.new()
      board = Board.new(s1, s2)
      expect(board.tie).to eq(false)
    end
    it "board should initialize with p1_winner as false" do
      s1 = Snake.new()
      s2 = Snake.new()
      board = Board.new(s1, s2)
      expect(board.p1_winner?).to eq(false)
    end
    it "board should initialize with p1 color as s1's color" do
      s1 = Snake.new()
      s2 = Snake.new()
      allow(s1).to receive(:color).and_return('yellow')
      board = Board.new(s1, s2)
      expect(board.p1color).to eq('yellow')
    end
    it "board should initialize with p1 color as s1's color" do
      s1 = Snake.new()
      s2 = Snake.new()
      allow(s1).to receive(:color).and_return('blue')
      board = Board.new(s1, s2)
      expect(board.p1color).to eq('blue')
    end
    it "board should initialize with p1 color as s1's color" do
      s1 = Snake.new()
      s2 = Snake.new()
      allow(s2).to receive(:color).and_return('red')
      board = Board.new(s1, s2)
      expect(board.p2color).to eq('red')
    end
  end
end
