class Snake

  attr_writer :new_direction
  attr_writer :z
  # snakes are initialized with a color and integer, player one of two
  # colors are ruby2d keywords
  def initialize(color, player)
    xpos = if player == 1
             GRID_WIDTH * 2 / 3
           else
             GRID_WIDTH / 3
           end
    @position = [[xpos, GRID_HEIGHT - 3], [xpos, GRID_HEIGHT - 4], [xpos, GRID_HEIGHT - 5]]
    @direction = 'up'
    @growing = @turned = false
    @snake_color = color
    @z = 0
  end
  # determines if the snake hit the wall of the other snake
  def hit_wall?(other_player)
    @position.pop
    @position += [other_player.head]
    crash?
  end

  def snake_color
    @snake_color.capitalize
  end
  # draws a snake with a gradient, illuminated effect
  def draw
    opacity = 0.4
    @position.reverse.each do |pos|
      opacity *= 0.8
      Square.new(x: pos[0] * GRID_SIZE, y: pos[1] * GRID_SIZE, size: NODE_SIZE, color: @snake_color, z: @z) # the regular snake
      Square.new(x: pos[0] * GRID_SIZE, y: pos[1] * GRID_SIZE, size: NODE_SIZE, color: 'white' , opacity: opacity, z: @z + 1) # a lighting effect
    end
  end

  def direction
    @direction
  end

  # ensures snake can only be turned once per clock tick
  def new_direction(dir)
    @direction = dir unless @turned
    @turned = true
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
    [x % GRID_WIDTH, y % GRID_HEIGHT]
  end

  # returns all slots occupied by the snake minus the head
  def body
    return @position.pop()
  end

  def position
    @position
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

  # returns true  if the snake has crashed into itself
  def crash?
    @position.length != @position.uniq.length
  end
end
