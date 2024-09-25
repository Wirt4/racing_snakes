load 'button.rb'
load 'settings.rb'
load 'directions.rb'
load 'player_ids.rb'

class Snake
# using color keywords so can id players in feedback.

  attr_accessor :position
  attr_reader :turned
  attr_accessor :growing
  attr_reader :z
  attr_accessor :direction
  attr_accessor :turned
  attr_reader :color

  # snakes are initialized with a color and integer, player one of two
  # colors are ruby2d keywords
  def initialize(player=PlayerIds::PLAYER_ONE)
    @playerButton = Button.new(player)
    set_staring_position(player)
    @z = 0
    @color = select_color(player)
    @direction = Directions::UP
    @growing = @turned = false
  end

  def set_staring_position(player_id)
    xpos = get_x_pos(player_id)
    end_range = Settings::START_Y_TAIL + Settings::START_LENGTH - 1
    @position = []
    (Settings::START_Y_TAIL..end_range).each do |n|
      position.push([xpos, Settings::GRID_HEIGHT - n])
    end
  end

  def get_x_pos(player_id)
    if player_id == PlayerIds::PLAYER_ONE
      return 2 * Settings::GRID_WIDTH / 3
    end
    return Settings::GRID_WIDTH / 3
  end

  def select_color(player_id)
    if player_id == PlayerIds::PLAYER_ONE
      return Settings::PLAYER_ONE_COLORS.sample
    end
    return Settings::PLAYER_TWO_COLORS.sample
  end

  # determines if the snake hit the wall of the other snake
  def hit_wall?(other_player)
    @position = body + [other_player.head]
    crash?
  end

  def color_name
    return @color.capitalize
  end

  # draws a snake
  def draw
    @position.each do |pos|
      draw_base(pos)
    end
  end

  def draw_base(node)
    Square.new(x: node[0] * Settings::GRID_SIZE, y: node[1] * Settings::GRID_SIZE, size: Settings::NODE_SIZE, color: @color, z: @z)
  end

  # ensures snake can only be turned once per clock tick
  def new_direction(dir)
    if @turned
      return
    end

    @direction = dir
    @turned = true
  end

  def is_allowable_direction(dir)
    case dir
      when Directions::UP
        return @direction != Directions::DOWN
      when Directions::LEFT
        return @direction != Directions::RIGHT
      when Directions::DOWN
        return @direction != Directions::UP
      when Directions::RIGHT
        return @direction != Directions::LEFT
    end
  end

  def set_allowable_direction(dir)
    if (is_allowable_direction(dir))
      new_direction(dir)
    end
  end

  # converts keystroke readings to a direction const if applicable
  def convert_direction(keystroke)
    case keystroke
    when @playerButton.up
      return Directions::UP
    when @playerButton.down
      return Directions::DOWN
    when @playerButton.left
      return Directions::LEFT
    when @playerButton.right
      return Directions::RIGHT
    end
    return false
  end

  def detect_key(keystroke)
    dir = convert_direction(keystroke)
    if dir !=false
      set_allowable_direction(dir)
    end
  end

  # moves snake along given direction once per clock tick
  def move
     @position.shift unless @growing
     case @direction
     when Directions::DOWN
       push_adjusted(head[0], head[1] + 1)
     when Directions::UP
       push_adjusted(head[0], head[1] - 1)
     when Directions::LEFT
       push_adjusted(head[0] - 1, head[1])
     when Directions::RIGHT
       push_adjusted(head[0] + 1, head[1])
     end
     @growing = @turned = false
  end

  def push_adjusted(x, y)
    @position.push([x % Settings::GRID_WIDTH, y % Settings::GRID_HEIGHT])
  end

  # returns all slots occupied by the snake minus the head
  def body
    return @position.pop()
  end

  def head
    @position.last
  end

  def x
    head[0]
  end

  def y
    head[1]
  end

  def grow
    @growing = true
  end

  def set_z(z)
    @z = z
  end

  # returns true  if the snake has crashed into itself
  def crash?
    @position.length != @position.uniq.length
  end
end
