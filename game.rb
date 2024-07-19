load 'game_clock.rb'
load 'snake.rb'

class Game
  attr_reader :player1
  attr_reader :player2

  def initialize()
    @clock = GameClock.new()
    color_1 = get_player_one_color()
    color_2 = get_player_two_color()
    @player1 = Snake.new(PlayerIds::PLAYER_ONE, color_1)
    @player2 = Snake.new(PlayerIds::PLAYER_TWO, color_2)
    @board = Board.new(color_1, color_2)
  end

  def draw_snakes()
    @player1.draw
    @player2.draw
  end

  def get_player_one_color()
    return Settings::PLAYER_TWO_COLORS.sample
  end

  def get_player_two_color()
    return Settings::PLAYER_TWO_COLORS.sample
  end
end
