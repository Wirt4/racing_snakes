
require 'ruby2d'
set background: 'black' # like the idea of yellow bg and fuchsia squares
set fps_cap: 15
set width: 1280
set height: 960
set title: 'Only Solutions'
set fullscreen: 'true'
GRID_SIZE = 20
GRID_WIDTH = Window.width/GRID_SIZE
GRID_HEIGHT = Window.height/GRID_SIZE
NODE_SIZE = GRID_SIZE
#COLORS = ['yellow', 'aqua','orange', 'red', 'fuchsia', 'silver']
# window is 640 by 480
# so grid is 32 by 24
class Snake

  attr_writer :new_direction

  def initialize(color, player)
    # intialize a snake object with a color and a choice of left or right position
    xpos = if player == 1
      8
    else
      24
           end
    @position = [[xpos, 22], [xpos, 21], [xpos, 20]]
    @direction = 'up'
    @growing = false
    @snake_color = color
  end

  def draw
    # iterate backwards through snake to re-draw and append colors in the correct order
    num = @position.length - 1
    @position.each do |pos|
      Square.new(x: pos[0] * GRID_SIZE, y: pos[1] * GRID_SIZE, size: NODE_SIZE, color: @snake_color)
      num -= 1
    end
  end

  def direction
    @direction
  end
# assumes method will only be called in event of a keystroke
  def turn(turn_dir)
    is_left = turn_dir =='left'
    @direction = if (is_left && @direction=='up')or(!is_left && @direction=='down')
      'left'
    elsif (is_left && @direction=='left')or(!is_left && @direction=='right')
      'down'
    elsif (is_left && @direction=='down')or(!is_left && @direction=='up')
        'right'
    else
      'up'
                   end
    end
  #def new_direction(dir)
  #  @direction = dir

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
    @growing = false
  end
  def new_coords(x,y)
    [x % GRID_WIDTH, y % GRID_HEIGHT]
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

  def grow(color)
    #@snake_colors.push(color)
    @growing = true
  end

  def collision?(other_snake_pos) # collision detection is not working as expected
    all_snake_pos = @position + other_snake_pos
    (all_snake_pos.uniq.length != all_snake_pos.length)
  end

end
# the game class, tracks score and displays feedback for player
class Game
  def initialize
    #@score = 0
    @food_x = rand(GRID_WIDTH) # may want a second method to spawn food to not to interfere with snake
    @food_y = rand(GRID_HEIGHT)
    @finished = false
    @food_color = 'white'
    @menu = true
  end
  def draw
    unless finished? or menu?
      Square.new(x: @food_x* GRID_SIZE, y: @food_y * GRID_SIZE, size: NODE_SIZE, color: @food_color)
    end
    if finished?
      msg = 'Dead snake. Press RETURN to play again.'
    else
      # msg = "Score: #{@score}"
    end
    Text.new(msg, color: 'black', x: 11, y: 11, size: 25)
    Text.new(msg, color: 'white', x: 10, y: 10, size: 25)
    if menu?
      Text.new('SNAKE RACE', color: 'white', x: 10, y: 40, size: 72)
      Text.new('press SPACE to play', color: 'white', x: 160, y: 160, size: 35)
    end
  end
  # players are full snake objects
  def winner(player_one, player_two)
    if player_one.head == player_two.head
      msg = 'Tie!'
      elsif (player_one.head + player_two.head).length
    end
  end

  def remove_menu
    @menu = false
  end
  def snake_eat_food?(x, y)
    @food_x == x && @food_y == y
  end
  def get_food_color
    @food_color
  end

  def respawn_food(pos)
    @food_x = rand(GRID_WIDTH)
    @food_y = rand(GRID_HEIGHT)
    while pos.include?([@food_x, @food_y])
      @food_x = rand(GRID_WIDTH)
      @food_y = rand(GRID_HEIGHT)
    end
  end
  def finish
    @finished = true
  end
  def menu?
    @menu
  end
  def finished?
    @finished
  end
end

game = Game.new
snake_1 = Snake.new('blue', 1)
snake_2 = Snake.new('red', 2)
snake_2.draw
snake_1.draw
update do
  #the cycle
  clear
  unless game.finished? or game.menu?
    snake_1.move
    snake_2.move
  end
  snake_1.draw
  snake_2.draw
  game.draw

  if game.snake_eat_food?(snake_1.x, snake_1.y)
    snake_1.grow(game.get_food_color)
    game.respawn_food(snake_1.position)
  end

  if snake_1.collision?(snake_2.position)
    game.finish
    game.winner (snake_1, snake_2)
  end
end

on :key_down do |event|
  #snake_1.new_direction('left') if event.key == 'left' && snake_1.direction != 'right'
  #snake_1.new_direction('right') if event.key =='right'&& snake_1.direction != 'left'
  #snake_1.new_direction('up') if event.key == 'up' && snake_1.direction != 'down'
  #snake_1.new_direction ('down') if event.key == 'down' && snake_1.direction != 'up'
  snake_1.turn('left') if event.key == 'left'
  snake_1.turn('right') if event.key == 'right'
  if event.key == 'return'
    snake_1 = Snake.new('blue', 1)
    game = Game.new
  end
  close if event.key == 'escape'
  game.remove_menu if event.key = 'space'
end
show
