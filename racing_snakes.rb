require 'ruby2d'
set background: 'black'
set width: 1520
set height: 845
set fps_cap: 20
set fullscreen: 'true'
GRID_SIZE = 30
GRID_WIDTH = Window.width/GRID_SIZE
GRID_HEIGHT = Window.height/GRID_SIZE
NODE_SIZE = GRID_SIZE # no spaces between links in snakes
PLAYER_ONE = 'yellow'
PLAYER_TWO = 'blue'
GAME_TITLE = 'SNAKE RACE'
PROMPT = 'Turn: '
TEXT_COLOR = 'white'
PLAYER_ONE_KEYS = 'A, W, S, D'
PLAYER_TWO_KEYS = 'Arrow Keys'

class Snake

  attr_writer :new_direction
  attr_writer :z
  def initialize(color, player)
    # intialize a snake object with a color and a choice of left or right position
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

  def hit_wall?(other_player)
    @position.pop
    @position += [other_player.head]
    crash?
  end

  def snake_color
    @snake_color.capitalize
  end

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

  def new_direction(dir)
    @direction = dir unless @turned
    @turned = true
  end

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
    @paused = true
    @tie = false
    @p1_winner = false
    @count = 0
  end

  def p1_winner?
    @p1_winner
  end

  def tie(bool)
    @tie = bool
  end

  def is_tie?(p1, p2)
    if p1.head[0]==p2.head[0]
      return tie_lemma?(1, p1, p2,'up', 'down')
    end
    if p1.head[1] == p2.head[1]
      return tie_lemma?(0, p1, p2, 'left', 'right')
    end
    false
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

public
  def draw
    unless finished? || menu?
      Square.new(x: @food_x* GRID_SIZE, y: @food_y * GRID_SIZE, size: NODE_SIZE, color: @food_color)
    end
    if menu?
      Text.new(GAME_TITLE, color: TEXT_COLOR, x: 70, y: 350, size: 72)
      Text.new('(press space)', color: TEXT_COLOR, x: 350, y: 425, size: 30)
    end
    Text.new(PROMPT + PLAYER_ONE_KEYS, color: PLAYER_ONE, x: 10, y: GRID_HEIGHT - GRID_SIZE , size: 30)
    Text.new(PROMPT + PLAYER_TWO_KEYS, color: PLAYER_TWO, x: 1280, y: GRID_HEIGHT - GRID_SIZE, size: 30)
  end

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

  def collision?(pos1, pos2)
    all_pos = pos1 + pos2
    (all_pos.uniq.length != all_pos.length)
  end

  def pause
    @paused = @paused ? false : true
  end

  def snake_eat_food?(x, y)
    @food_x == x && @food_y == y
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
    @paused
  end

  def finished?
    @finished
  end
end

count = 0
gold_snake = Snake.new(PLAYER_ONE, 1)
blue_snake = Snake.new(PLAYER_TWO, 2)
game = Game.new
blue_snake.draw
gold_snake.draw
update do
  #the cycle
  clear

  unless game.finished? or game.menu?
    game.tie(game.is_tie?(gold_snake, blue_snake))
    gold_snake.move
    blue_snake.move
    count += 1
  end
  gold_snake.draw
  blue_snake.draw
  game.draw

  if game.snake_eat_food?(gold_snake.x, gold_snake.y)
    gold_snake.grow
    game.respawn_food(gold_snake.position + blue_snake.position)
    count = 0
  end

  if game.snake_eat_food?(blue_snake.x, blue_snake.y)
    blue_snake.grow
    game.respawn_food(gold_snake.position + blue_snake.position)
    count = 0
  end
# randomise the food appearences in case some poor sport decides to start circling it
  if count > 20 * rand(15..20)
    count = 0
    game.respawn_food(gold_snake.position + blue_snake.position)
  end

  if game.collision?(gold_snake.position, blue_snake.position)
    game.finish
    Text.new(game.winner(gold_snake, blue_snake), color: 'white', x: 70, y: 350, size: 72)
    # Text.new('(ENTER to play again, ESC to exit)', color: 'white', x: 70, y: 425, size: 30)
    if game.p1_winner?
      blue_snake.z = 5
    else
      gold_snake.z = 5
    end
  end
end

on :key_down do |event|
#keeping gold snake on a left/right model for comparitive testing

  blue_snake.new_direction('left') if event.key == 'left' && blue_snake.direction != 'right'
  blue_snake.new_direction('right') if event.key == 'right' && blue_snake.direction != 'left'
  blue_snake.new_direction('up') if event.key == 'up' && blue_snake.direction != 'down'
  blue_snake.new_direction('down') if event.key == 'down' && blue_snake.direction != 'up'

  gold_snake.new_direction('left') if event.key == 'a' && gold_snake.direction != 'right'
  gold_snake.new_direction('right') if event.key == 'd' && gold_snake.direction != 'left'
  gold_snake.new_direction('up') if event.key == 'w' && gold_snake.direction != 'down'
  gold_snake.new_direction('down') if event.key == 's' && gold_snake.direction != 'up'

  if game.finished? && event.key == 'space'
    gold_snake = Snake.new(PLAYER_ONE, 1)
    blue_snake = Snake.new(PLAYER_TWO, 2)
    game = Game.new
  end

  close if event.key == 'escape'
  game.pause if event.key =='space'
end
show
