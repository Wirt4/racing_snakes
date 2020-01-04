
require 'ruby2d'
set background: 'black' # like the idea of yellow bg and fuchsia squares
set fps_cap: 20
set width: 1600
set height: 900
set fullscreen: 'true'
GRID_SIZE = 20
GRID_WIDTH = Window.width/GRID_SIZE
GRID_HEIGHT = Window.height/GRID_SIZE
NODE_SIZE = GRID_SIZE # no spaces between links in snakes
GOLD_PLAYER = 'yellow'
BLUE_PLAYER = 'aqua'
#grid size is 64 * 48

class Snake

  attr_writer :new_direction
  attr_writer :z
  def initialize(color, player)
    # intialize a snake object with a color and a choice of left or right position
    if player == 1
             xpos =  GRID_WIDTH / 3
           else
             xpos = GRID_WIDTH * 2 / 3
           end
    #   @position = [[xpos, GRID_HEIGHT - 3], [xpos, GRID_HEIGHT - 4], [xpos, GRID_HEIGHT - 5]]
    @position = [[xpos, GRID_HEIGHT - 3], [xpos, GRID_HEIGHT - 4]]
    @direction = 'up'
    @growing = false
    @snake_color = color
    @z = 0
  end
  def hit_wall?(other_player)
    @position.pop
    @position += [other_player.head]
    crash?
  end
  def draw
    opacity = 0.1
    num = 5
    @position.each do |pos|
      opacity *= 1.1
     Square.new(x: pos[0] * GRID_SIZE, y: pos[1] * GRID_SIZE, size: NODE_SIZE, color: @snake_color, z: @z) # the regular snake
        Square.new(x: pos[0] * GRID_SIZE, y: pos[1] * GRID_SIZE, size: NODE_SIZE, color: 'white' , opacity: opacity, z: @z + 1) # a lighting effect
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

  def crash?
    @position.length != @position.uniq.length
  end

end
# the game class, tracks score and displays feedback for player
class Game
  def initialize
    @food_x = GRID_WIDTH / 2
    @food_y = GRID_HEIGHT / 3
    @finished = false
    @food_color = 'white'
    @menu = true
    @tie = false
    @blue_winner = false
  end
  def blue_winner?
    @blue_winner
  end
  def tie(bool)
    @tie = bool
  end
  def check_for_tie(p1, p2)
    if p1.head[0]==p2.head[0]
      if p1.head[1]-1 ==p2.head[1]&& p1.direction=='up'&& p2.direction=='down'
        return true
      end
      if p1.head[1]+1==p2.head[1]&&p1.direction=='down'&& p2.direction=='up'
        return true
      end
    elsif p1.head[1]==p2.head[1]
      if p1.head[0]-1 == p2.head[0] && p1.direction=='left'&& p2.direction=='right'
        return true
      end
      if p1.head[0] + 1 == p2.head[0] && p1.direction=='right'&& p2.direction =='left'
        return true
      end
    end
    return false
  end
  def draw
    unless finished? || menu?
      Square.new(x: @food_x* GRID_SIZE, y: @food_y * GRID_SIZE, size: NODE_SIZE, color: @food_color)
    end
    if menu?
      Text.new('SNAKE RACE', color: 'white', x: 10, y: 40, size: 72)
      Text.new('press SPACE to play', color: 'white', x: 160, y: 160, size: 35)
    end
    Text.new('Move: Z, X,', color: GOLD_PLAYER, x: 10, y: 860 , size: 30)
    Text.new('Move: Arrow Keys', color: BLUE_PLAYER, x: 1340, y: 860, size: 30)
  end

  def winner(gold_player, blue_player)
    if @tie
      return 'Tie'
      end
    if gold_player.crash?  || blue_player.hit_wall?(gold_player)
      return 'Blue Wins'
      @blue_winner = true
    end
      return 'Gold Wins'
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

gold_snake = Snake.new(GOLD_PLAYER, 1)
blue_snake = Snake.new(BLUE_PLAYER, 2)
game = Game.new
blue_snake.draw
gold_snake.draw
update do
  #the cycle
  clear
  unless game.finished? or game.menu?
    game.tie(game.check_for_tie(gold_snake, blue_snake))
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
    Text.new(game.winner(gold_snake, blue_snake), color: 'white', x: 70, y: 350, size: 72)
    if game.blue_winner?
      blue_snake.z = 5
    else
      gold_snake.z = 5
    end
  end
end

on :key_down do |event|
  gold_snake.turn('left') if event.key == 'z'
  gold_snake.turn('right') if event.key == 'x'
  blue_snake.turn('left') if event.key =='left'
  blue_snake.turn('right') if event.key =='right'
  if event.key == 'return'
    gold_snake = Snake.new(GOLD_PLAYER, 1)
    blue_snake = Snake.new(BLUE_PLAYER, 2)
    game = Game.new
  end
  close if event.key == 'escape'
  game.remove_menu if event.key = 'space'
end
show
