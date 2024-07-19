load 'game_clock.rb'
load 'snake.rb'

class Game
  def initialize()
    @clock = GameClock.new()
    @player1 = Snake.new(PlayerIds::PLAYER_ONE)
    @player2 = Snake.new(PlayerIds::PLAYER_TWO)
  end
end
