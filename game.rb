load 'game_clock.rb'
load 'snake.rb'

class Game
  attr_reader :player1
  attr_reader :player2
  attr_reader :board
  attr_reader :clock
  attr_accessor :player1Eats
  attr_accessor :player2Eats

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

  def draw_board()
    draw_snakes
    @board.draw
    @player1Eats = @board.snake_eat_food?(@player1)
    @player2Eats = @board.snake_eat_food?(@player2)
  end

  def is_paused?()
    return board.finished? || board.menu?
  end

  def move()
    @board.is_tie(@player1, @player2)
    @player1.move
    @player2.move
    @clock.increment
  end

  def player_eats()
    return @player1Eats || @player2Eats
  end

  def eat_and_grow()
    if player1Eats
      @player1.grow
    end
    if player2Eats
      @player2.grow
    end

    respawn_food
  end

  def food_time?()
    return @clock.is_food_time
  end

  def respawn_food()
    @clock.reset
    @board.respawn_food(@player1.position + @player2.position)
  end

  def is_collision?()
    return @board.collision?([[42, 33], [42, 32], [42, 31]], [[21, 33], [21, 32], [21, 31]])
  end

end
