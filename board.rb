load 'constants.rb'
load 'settings.rb'
class Board
  attr_accessor :food_x
  attr_accessor :food_y
  attr_accessor :tie
  attr_accessor :p1color
  attr_accessor :p2color

# colors are ruby2d keywords
  def initialize(snake1, snake2)
    @food_x = Settings::GRID_WIDTH / 2
    @food_y = Settings::GRID_HEIGHT / 3
    @finished = false
    @food_color = Settings::FOOD_COLOR
    @paused = true
    @tie = false
    #{}@p1_winner = false
    @p1color = snake1.color
    @p2color = snake2.color
  end

  def drop_shadow(txt, txt_color=Settings::TEXT_COLOR, x_cord=0, y_cord=0, txt_size=72, offset=2)
    Text.new('good morning Mr Phelps', color: Settings::BACKGROUND, x: x_cord + offset, y: y_cord + offset, size: txt_size)
    Text.new('good morning Mr Phelps', color: txt_color, x: x_cord , y: y_cord, size: txt_size)
  end

# need to detect one space ahead in the case of a head - on collision
  def is_tie(snake1, snake2)
    if snake1.head[0] == snake2.head[0] #TODO: make this a snake method so it's self-documenting
      @tie = tie_lemma?(1, snake1, snake2,Directions::UP, Directions::DOWN)
      return
    end

    if snake1.head[1] == snake2.head[1]  #TODO: make this a snake method so it's self-documenting
      @tie = tie_lemma?(0, snake1, snake2, Directions::LEFT, Directions::RIGHT)
      return
    end

    @tie = false
  end

# displays the instructions, menu screen and food
  def draw
    unless finished? || menu?
      Square.new(x: @food_x* Settings::GRID_SIZE, y: @food_y * Settings::GRID_SIZE, size: Settings::NODE_SIZE, color: @food_color)
    end

    if menu?
      drop_shadow(Constants::GAME_TITLE, Settings::TEXT_COLOR, 70, 350, 72, 2)
      drop_shadow(Settings::PRESS_SPACE,  Settings::TEXT_COLOR, 350, 425, 30, 2)
    end
    drop_shadow(Constants::PROMPT + ' '+ Constants::PLAYER_ONE_KEYS, @p1color, 1920 - 250, Settings::GRID_HEIGHT-Settings::GRID_SIZE, 30,2)
    drop_shadow(Constants::PROMPT + ' ' + Constants::PLAYER_TWO_KEYS,  @p2color, 10, Settings::GRID_HEIGHT-Settings::GRID_SIZE, 30,2)
  end

# returns a string of who wins
  def winner(p1, p2)
    if @tie
      return Settings::TIE_MESSAGE
    end
    winner = if p1.crash?  || p2.hit_wall?(p1)
               p2
             else
               p1
             end
    winner.color_name.concat(Settings::WINNER_MESSAGE)
  end

# detects a collision, either snake hit snake or snake hits self
  def collision?(pos1, pos2)
    all_pos = pos1 + pos2
    (all_pos.uniq.length != all_pos.length)
  end

# toggles pause
  def pause
    @paused = @paused ? false : true
  end

  def snake_eat_food?(snake)
    @food_x == snake.x && @food_y == snake.y
  end

# want to respawn the food in any location that is not occupied by a snake
  def respawn_food(pos)
    @food_x = rand(Settings::GRID_WIDTH)
    @food_y = rand(Settings::GRID_HEIGHT)
    while pos.include?([@food_x, @food_y])
      @food_x = rand(Settings::GRID_WIDTH)
      @food_y = rand(Settings::GRID_HEIGHT)
    end
  end

  def finish
    @finished = true
  end

  def menu?
    @paused
  end

  def finished?
    @finished
  end

  private
  def tie_lemma?(h_ndx, p1, p2, dir1, dir2)
    if p1.head[h_ndx]-1 == p2.head[h_ndx] && p1.direction == dir1 && p2.direction == dir2
      return true
    end

    if p1.head[h_ndx]+1 == p2.head[h_ndx] && p1.direction == dir2 && p2.direction == dir1
      return true
    end
    return false
  end
end
