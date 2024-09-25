require 'rspec'
require 'ruby2d'
load 'board.rb'
load 'snake.rb'
load 'coordinates.rb'

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

  describe 'drop_shadow tests'do
    it "copy in drop shadow method should be passed to the Text object" do
      allow(Text).to receive(:new)
      s1 = Snake.new()
      s2 = Snake.new()
      board = Board.new(s1, s2)
      board.drop_shadow('good morning Mr Phelps')
      expect(Text).to have_received(:new).with("good morning Mr Phelps", anything).twice()
    end
    it "copy in drop shadow method should be passed to the Text object - different data" do
      allow(Text).to receive(:new)
      s1 = Snake.new()
      s2 = Snake.new()
      board = Board.new(s1, s2)
      board.drop_shadow('Look I made a hat')
      expect(Text).to have_received(:new).with('Look I made a hat', anything).twice()
    end
    it 'coorindates in coords object should be passed to the text objec' do
      allow(Text).to receive(:new)
      s1 = Snake.new()
      s2 = Snake.new()
      board = Board.new(s1, s2)
      coords = Coordinates.new(7, 8)
      board.drop_shadow('Look I made a hat', coords)
      expect(Text).to have_received(:new).with(anything,{:color=>anything, :size=>anything, :x=>7, :y=>8})
    end
  end
  describe 'draw tests' do
    it 'check player two keys have been printed' do
      s1 = Snake.new()
      s2 = Snake.new()
      board = Board.new(s1, s2)
      allow(board).to receive(:drop_shadow)

      board.draw

      expect(board).to have_received(:drop_shadow).with("Turn: W, A, S, D", anything, anything, anything)
    end
    it 'check player two keys have been printed' do
      s1 = Snake.new()
      s2 = Snake.new()
      board = Board.new(s1, s2)
      allow(board).to receive(:drop_shadow)

      board.draw

      expect(board).to have_received(:drop_shadow).with("Turn: Arrow Keys", anything, anything, anything)
    end
  end
end
