load 'constants.rb'
load 'settings.rb'
load 'coordinates.rb'
class Board
  attr_accessor :food_x
  attr_accessor :food_y
  attr_accessor :tie
  attr_accessor :p1color
  attr_accessor :p2color
  attr_accessor :finished

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

  def drop_shadow(txt, coords=Coordinates.new, txt_color=Settings::TEXT_COLOR, txt_size=72)
    offset = 2
    Text.new(txt, color: Settings::BACKGROUND, x: coords.x + offset, y: coords.y + offset, size: txt_size)
    Text.new(txt, color: txt_color, x:coords.x, y: coords.y, size: txt_size)
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

  def display_menu_prompts
    heading_coords = Coordinates.new(70, 350)
    heading_size = 72
    subheading_coords = Coordinates.new(350, 425)
    subheading_size = 30

    drop_shadow(Constants::GAME_TITLE, heading_coords,Settings::TEXT_COLOR, heading_size)
    drop_shadow(Settings::PRESS_SPACE,  subheading_coords,Settings::TEXT_COLOR,  subheading_size)
  end

  def prompt(player)
    if player == PlayerIds::PLAYER_ONE
      keys = Constants::PLAYER_ONE_KEYS
    else
      keys = Constants::PLAYER_TWO_KEYS
    end
    return Constants::PROMPT + ' ' + keys
  end

  def display_player_keys
    prompt_size = 30
    p1_coords = Coordinates.new(1920 - 250,Settings::GRID_HEIGHT-Settings::GRID_SIZE)
    p2_coords = Coordinates.new(10, Settings::GRID_HEIGHT-Settings::GRID_SIZE)
    drop_shadow(prompt(PlayerIds::PLAYER_ONE), p1_coords,@p1color, prompt_size)
    drop_shadow(prompt(PlayerIds::PLAYER_TWO), p2_coords, @p2color,prompt_size)
  end

# displays the instructions, menu screen and food
  def draw
    unless finished? || menu?
      Square.new(x: @food_x* Settings::GRID_SIZE, y: @food_y * Settings::GRID_SIZE, size: Settings::NODE_SIZE, color: @food_color)
    end

    if menu?
      display_menu_prompts()
    end

    display_player_keys()
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
