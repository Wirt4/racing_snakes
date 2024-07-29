load 'button.rb'
load 'settings.rb'
load 'directions.rb'

class Snake
# using color keywords so can id players in feedback.

  attr_accessor :position
  attr_reader :turned
  attr_accessor :growing
  attr_reader :z
  attr_accessor :direction
  attr_accessor :turned

  # snakes are initialized with a color and integer, player one of two
  # colors are ruby2d keywords
  def initialize(player=PlayerIds::PLAYER_ONE, color="red")
    @playerButton = Button.new(player)

    xpos = Settings::GRID_WIDTH / 3

    if player== PlayerIds::PLAYER_ONE
      xpos *= 2
    end

    @snake_color = color
    @position = []
    (3..5).each do |n|
      position.push([xpos, Settings::GRID_HEIGHT - n])
    end

    @direction = Directions::UP
    @growing = @turned = false
    @z = 0
  end
  # determines if the snake hit the wall of the other snake
  def hit_wall?(other_player)
    @position = body + [other_player.head]
    crash?
  end

  def color_name
    return @snake_color.capitalize
  end
  # draws a snake
  def draw
    @position.each do |pos|
      draw_base(pos)
    end
  end

  def draw_base(node)
    Square.new(x: node[0] * Settings::GRID_SIZE, y: node[1] * Settings::GRID_SIZE, size: Settings::NODE_SIZE, color: @snake_color, z: @z)
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

  def detect_key(keystroke)
    if keystroke==@playerButton.left
      case @direction
      when Directions::RIGHT
        set_allowable_direction(Directions::UP)
      when Directions::UP
        set_allowable_direction(Directions::LEFT)
      when Directions::LEFT
        set_allowable_direction(Directions::DOWN)
      when Directions::DOWN
        set_allowable_direction(Directions::RIGHT)
      end
    elsif keystroke == @playerButton.right
      case @direction
      when Directions::RIGHT
        set_allowable_direction(Directions::DOWN)
      when Directions::UP
        set_allowable_direction(Directions::RIGHT)
      when Directions::LEFT
        set_allowable_direction(Directions::UP)
      when Directions::DOWN
        set_allowable_direction(Directions::LEFT)
      end
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
