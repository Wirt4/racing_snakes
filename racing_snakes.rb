# Written January 2020 by Wirt Salthouse
# github.com/Wirt4
require 'ruby2d'
set background: 'black'
set width: 1920
set height: 1080
set fps_cap: 20
set fullscreen: 'true'
GRID_SIZE = 30
GRID_WIDTH = Window.width/GRID_SIZE
GRID_HEIGHT = Window.height/GRID_SIZE
NODE_SIZE = GRID_SIZE
GAME_TITLE = 'SNAKE RACE'
PROMPT = 'Turn: '
TEXT_COLOR = 'white'
PLAYER_ONE_KEYS = 'A, W, S, D'
PLAYER_TWO_KEYS = 'Arrow Keys'

# using color keywords so can id players in feedback.
PLAYER_ONE_COLORS = ['yellow', 'orange', 'red', ]
PLAYER_TWO_COLORS = ['fuchsia', 'blue', 'green', ]

class Snake

  attr_writer :new_direction
  attr_writer :z
  # snakes are initialized with a color and integer, player one of tow
  # colors are ruby2d keywords
  def initialize(color, player)
    xpos = if player == 1
             GRID_WIDTH / 3
           else
             GRID_WIDTH * 2 / 3
           end
    @position = [[xpos, GRID_HEIGHT - 3], [xpos, GRID_HEIGHT - 4], [xpos, GRID_HEIGHT - 5]]
    # @position = [[xpos, GRID_HEIGHT - 3], [xpos, GRID_HEIGHT - 4]]
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

class Game

# initializes with the colors of the players so can print the instructions unobtrusively
# colors are ruby2d keywords
  def initialize(p1color, p2color)
    @food_x = GRID_WIDTH / 2
    @food_y = GRID_HEIGHT / 3
    @finished = false
    @food_color = 'white'
    @paused = true
    @tie = false
    @p1_winner = false
    @p1color = p1color
    @p2color = p2color
  end


  def p1_winner?
    @p1_winner
  end

  def tie(bool)
    @tie = bool
  end
# a cheesy effect, but helps make all the text readable
  def drop_shadow(txt, txt_color, x_cord, y_cord, txt_size, offset)
    Text.new(txt, color: 'black', x: x_cord + offset, y: y_cord + offset, size: txt_size)
    Text.new(txt, color: txt_color, x: x_cord , y: y_cord, size: txt_size)
  end

# need to detect one space ahead in the case of a head - on collision
  def is_tie?(p1, p2)
    if p1.head[0]==p2.head[0]
      return tie_lemma?(1, p1, p2,'up', 'down')
    end
    if p1.head[1] == p2.head[1]
      return tie_lemma?(0, p1, p2, 'left', 'right')
    end
    false
  end

# displays the instructions, menu screen and food
  def draw
    unless finished? || menu?
      Square.new(x: @food_x* GRID_SIZE, y: @food_y * GRID_SIZE, size: NODE_SIZE, color: @food_color)
    end

    if menu?
      drop_shadow(GAME_TITLE, TEXT_COLOR, 70, 350, 72, 2)

      drop_shadow('(press space)',  TEXT_COLOR, 350, 425, 30, 2)
    end
    drop_shadow(PROMPT + PLAYER_ONE_KEYS,  @p1color, 10, GRID_HEIGHT-GRID_SIZE, 30,2)
    drop_shadow(PROMPT + PLAYER_TWO_KEYS, @p2color, 1920 - 250, GRID_HEIGHT-GRID_SIZE, 30,2)
  end

# returns a string of who wins
  def winner(p1, p2)
    if @tie
      return 'Tie'
    end
    winner = if p1.crash?  || p2.hit_wall?(p1)
               p2
             else
               p1
             end
    winner.snake_color.concat(' Wins')
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

  def snake_eat_food?(x, y)
    @food_x == x && @food_y == y
  end

# want to respawn the food in any location that is not occupied by a snake
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
    @paused
  end

  def finished?
    @finished
  end

  private
  def tie_lemma?(h_ndx, p1, p2, dir1, dir2)
    if p1.head[h_ndx]-1 == p2.head[h_ndx]&& p1.direction == dir1 && p2.direction == dir2
      return true
    end
    if p1.head[h_ndx]+1 == p2.head[h_ndx] && p1.direction == dir2 && p2.direction== dir1
      return true
    end
    false
  end

end

tick = 0 # count for tracking game time and respawning food if no effect
p1color = PLAYER_ONE_COLORS.sample
p2color = PLAYER_TWO_COLORS.sample
player1 = Snake.new(p1color, 1)
player2 = Snake.new(p2color, 2)
game = Game.new(p1color, p2color)
player2.draw
player1.draw
# the game cylce
update do
  clear

  unless game.finished? or game.menu?
    game.tie(game.is_tie?(player1, player2))
    player1.move
    player2.move
    tick += 1
  end
  player1.draw
  player2.draw
  game.draw

  if game.snake_eat_food?(player1.x, player1.y)
    player1.grow
    game.respawn_food(player1.position + player2.position)
    tick = 0
  end

  if game.snake_eat_food?(player2.x, player2.y)
    player2.grow
    game.respawn_food(player1.position + player2.position)
    tick = 0
  end

# randomises the food appearences between 15 and 20 seconds since game start or last food eats
  if tick > 20 * rand(15..20)
    tick = 0
    game.respawn_food(player1.position + player2.position)
  end

# prints out the winner of the game if it ends
  if game.collision?(player1.position, player2.position)
    game.finish
    game.drop_shadow(game.winner(player1, player2), TEXT_COLOR, 70, 350, 72, 2)
    if game.p1_winner?
      player2.z = 5
    else
      player1.z = 5
    end
  end
end

#player controls, is up, down, left, right /AWSD
on :key_down do |event|

  player2.new_direction('left') if event.key == 'left' && player2.direction != 'right'
  player2.new_direction('right') if event.key == 'right' && player2.direction != 'left'
  player2.new_direction('up') if event.key == 'up' && player2.direction != 'down'
  player2.new_direction('down') if event.key == 'down' && player2.direction != 'up'

  player1.new_direction('left') if event.key == 'a' && player1.direction != 'right'
  player1.new_direction('right') if event.key == 'd' && player1.direction != 'left'
  player1.new_direction('up') if event.key == 'w' && player1.direction != 'down'
  player1.new_direction('down') if event.key == 's' && player1.direction != 'up'

# restarts the game, otherwise the space key just pauses it
  if game.finished? && event.key == 'space'
    p1color = PLAYER_ONE_COLORS.sample
    p2color = PLAYER_TWO_COLORS.sample
    player1 = Snake.new(p1color, 1)
    player2 = Snake.new(p2color, 2)
    game = Game.new(p1color, p2color)
  end

  close if event.key == 'escape'
  game.pause if event.key =='space'
end
show
