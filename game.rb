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
    return @board.collision?(@player1.position, @player2.position)
  end

  def stop_game()
    @board.finish
    winner = @board.winner(@player1, @player2)
    @board.drop_shadow(winner,  Settings::TEXT_COLOR, Settings::WINNER_MSG_X, Settings::WINNER_MSG_Y)
    if (@board.p1_winner?)
      @player1.set_z(Settings::WINNER_Z_NDX)
    else
      @player2.set_z(Settings::WINNER_Z_NDX)
    end
  end

  def detect_key(k)
    @player1.detect_key(k)
    @player2.detect_key(k)

    if (board.finished? && k == Keyboard::SPACE)
      player1_color = Settings::PLAYER_ONE_COLORS.sample
      player2_color = Settings::PLAYER_TWO_COLORS.sample
      @player1 = Snake.new(1, player1_color)
      @player2 = Snake.new(2, player2_color)
      @board = Board.new(player1_color, player2_color)
    end

    if (k == Keyboard::SPACE)
      pause
    end
  end

  def pause
    @board.pause
  end
end
