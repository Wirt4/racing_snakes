load 'button.rb'
load 'settings.rb'
load 'directions.rb'

class Snake
# using color keywords so can id players in feedback.

  attr_accessor :position
  attr_reader :turned
  attr_reader :growing
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
    @direction = dir unless @turned
    @turned = true
  end

  def detect_key(keystroke)

      new_direction('left') if keystroke == @playerButton.left && direction != 'right'
      new_direction('right') if keystroke == @playerButton.right && direction != 'left'
      new_direction('up') if keystroke == @playerButton.up && direction != 'down'
      new_direction('down') if keystroke == @playerButton.down && direction != 'up'
  end

  # moves snake along given direction once per clock tick
  def move
    @position.shift unless @growing
    case @direction
    when 'down'
      @position.push(new_coords(head[0], head[1] + 1))
    when 'up'
      @position.push(new_coords(head[0], head[1] - 1))
    when 'left'
      @position.push(new_coords(head[0] - 1, head[1]))
    when 'right'
      @position.push(new_coords(head[0] + 1, head[1]))
    end
    @growing = @turned = false
  end

  # creates the "infinite canvas" feel
  def new_coords(x,y)
    [x % Settings::GRID_WIDTH, y % Settings::GRID_HEIGHT]
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
