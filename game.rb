load 'game_clock.rb'
load 'snake.rb'

class Game
  attr_reader :player1
  attr_reader :player2

  def initialize()
    @clock = GameClock.new()
    @player1 = Snake.new(PlayerIds::PLAYER_ONE)
    @player2 = Snake.new(PlayerIds::PLAYER_TWO)
    @board = Board.new(@player1.color, @player2.color)
  end

  def draw_snakes()
    @player1.draw
    @player2.draw
  end
end
