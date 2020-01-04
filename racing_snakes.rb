
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
NODE_SIZE = GRID_SIZE # no spaces between links in snakes

class Snake

  attr_writer :new_direction

  def initialize(color, player)
    # intialize a snake object with a color and a choice of left or right position
    if player == 1
             xpos =  8
           else
             xpos = 24
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
    @direction = if (is_left && @direction =='up')or(!is_left && @direction =='down')
      'left'
    elsif (is_left && @direction =='left')or(!is_left && @direction =='right')
      'down'
    elsif (is_left && @direction =='down')or(!is_left && @direction =='up')
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

  def grow
    @growing = true
  end

  def crash? # checks if the snake has run into itself
    # all_snake_pos = @position + other_snake_pos
    (@position.uniq.length != @position.length)
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
    unless finished? || menu?
      Square.new(x: @food_x* GRID_SIZE, y: @food_y * GRID_SIZE, size: NODE_SIZE, color: @food_color)
    end
    #Text.new(msg, color: 'black', x: 11, y: 11, size: 25)
    #Text.new(msg, color: 'white', x: 10, y: 10, size: 25)
    if menu?
      Text.new('SNAKE RACE', color: 'white', x: 10, y: 40, size: 72)
      Text.new('press SPACE to play', color: 'white', x: 160, y: 160, size: 35)
    end
  end
  # players are full snake objects
  # assumes there is a collision
  def winner(player_one, player_two)
    if player_one.head == player_two.head
      msg = 'Tie!'
    elsif player_one.crash? || collision?(player_two.position, [player_one.head])
      msg = 'Blue Wins!'
    elsif player_two.crash? || collision?(player_one.position, [player_two.head])
      msg = 'Gold Wins!'
    end
    Text.new(msg, color: 'white', x: 10, y: 40, size: 72)
  end
  def collision?(pos1, pos2)
    all_pos = pos1 + pos2
    (all_pos.uniq.length != all_pos.length)
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

gold_snake = Snake.new('yellow', 1)
blue_snake = Snake.new('blue', 2)
game = Game.new
blue_snake.draw
gold_snake.draw
update do
  #the cycle
  clear
  unless game.finished? or game.menu?
    gold_snake.move
    blue_snake.move
  end
  gold_snake.draw
  blue_snake.draw
  game.draw

  if game.snake_eat_food?(gold_snake.x, gold_snake.y)
    gold_snake.grow
    game.respawn_food(gold_snake.position + blue_snake.position)
  end

  if game.snake_eat_food?(blue_snake.x, blue_snake.y)
    blue_snake.grow
    game.respawn_food(gold_snake.position + blue_snake.position)
  end

  if game.collision?(gold_snake.position, blue_snake.position)
    game.finish
    game.winner(gold_snake, blue_snake)
  end
end

on :key_down do |event|
  gold_snake.turn('left') if event.key == 'a'
  gold_snake.turn('right') if event.key == 's'
  blue_snake.turn('left') if event.key =='left'
  blue_snake.turn('right') if event.key =='right'
  if event.key == 'return'
    gold_snake = Snake.new('yellow', 1)
    blue_snake = Snake.new('blue', 2)
    game = Game.new
  end
  close if event.key == 'escape'
  game.remove_menu if event.key = 'space'
end
show
