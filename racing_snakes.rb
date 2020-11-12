# Written January 2020 by Wirt Salthouse
# github.com/Wirt4
require 'ruby2d'

load 'game.rb'
load 'snake.rb'
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

# class Snake

#   attr_writer :new_direction
#   attr_writer :z
#   # snakes are initialized with a color and integer, player one of tow
#   # colors are ruby2d keywords
#   def initialize(color, player)
#     xpos = if player == 1
#              GRID_WIDTH / 3
#            else
#              GRID_WIDTH * 2 / 3
#            end
#     @position = [[xpos, GRID_HEIGHT - 3], [xpos, GRID_HEIGHT - 4], [xpos, GRID_HEIGHT - 5]]
#     # @position = [[xpos, GRID_HEIGHT - 3], [xpos, GRID_HEIGHT - 4]]
#     @direction = 'up'
#     @growing = @turned = false
#     @snake_color = color
#     @z = 0
#   end
#   # determines if the snake hit the wall of the other snake
#   def hit_wall?(other_player)
#     @position.pop
#     @position += [other_player.head]
#     crash?
#   end

#   def snake_color
#     @snake_color.capitalize
#   end
#   # draws a snake with a gradient, illuminated effect
#   def draw
#     opacity = 0.4
#     @position.reverse.each do |pos|
#       opacity *= 0.8
#       Square.new(x: pos[0] * GRID_SIZE, y: pos[1] * GRID_SIZE, size: NODE_SIZE, color: @snake_color, z: @z) # the regular snake
#       Square.new(x: pos[0] * GRID_SIZE, y: pos[1] * GRID_SIZE, size: NODE_SIZE, color: 'white' , opacity: opacity, z: @z + 1) # a lighting effect
#     end
#   end

#   def direction
#     @direction
#   end

#   # ensures snake can only be turned once per clock tick
#   def new_direction(dir)
#     @direction = dir unless @turned
#     @turned = true
#   end

#   # moves snake along given direction once per clock tick
#   def move
#     @position.shift unless @growing
#     case @direction
#     when 'down'
#       @position.push(new_coords(head[0], head[1] + 1))
#     when 'up'
#       @position.push(new_coords(head[0], head[1] - 1))
#     when 'left'
#       @position.push(new_coords(head[0] - 1, head[1]))
#     when 'right'
#       @position.push(new_coords(head[0] + 1, head[1]))
#     end
#     @growing = @turned = false
#   end

#   # creates the "infinite canvas" feel
#   def new_coords(x,y)
#     [x % GRID_WIDTH, y % GRID_HEIGHT]
#   end

#   # returns all slots occupied by the snake minus the head
#   def body
#     return @position.pop()
#   end

#   def position
#     @position
#   end

#   def head
#     @position.last
#   end

#   def x
#     head[0]
#   end

#   def y
#     head[1]
#   end

#   def grow
#     @growing = true
#   end

#   # returns true  if the snake has crashed into itself
#   def crash?
#     @position.length != @position.uniq.length
#   end
# end



tick = 0 # count for tracking game time and respawning food if no effect
p1color = PLAYER_ONE_COLORS.sample
p2color = PLAYER_TWO_COLORS.sample
#twoPlayers = false
player2 = Snake.new(p1color, 2) 
player1 = Snake.new(p2color, 1)
game = Game.new(p1color, p2color)
player2.draw 
player1.draw

# the game cylce
update do
  clear

  unless game.finished? or game.menu?
    game.tie(game.is_tie?(player2, player1))
    player2.move 
    player1.move
    tick += 1
  end
  player2.draw 
  player1.draw
  game.draw

  if game.snake_eat_food?(player2.x, player2.y)
    player2.grow 
    game.respawn_food(player2.position + player1.position)
    tick = 0
  end

  if game.snake_eat_food?(player1.x, player1.y)
    player1.grow
    game.respawn_food(player2.position + player1.position)
    tick = 0
  end

# randomises the food appearences between 15 and 20 seconds since game start or last food eats
  if tick > 20 * rand(15..20)
    tick = 0
    game.respawn_food(player2.position + player1.position)
  end

# prints out the winner of the game if it ends
  if game.collision?(player2.position, player1.position)
    game.finish
    game.drop_shadow(game.winner(player2, player1), TEXT_COLOR, 70, 350, 72, 2)
    if game.p1_winner?
      player1.z = 5
    else
      player2.z = 5
    end
  end
end

#player controls, is up, down, left, right /AWSD
on :key_down do |event|

  player1.new_direction('left') if event.key == 'left' && player1.direction != 'right'
  player1.new_direction('right') if event.key == 'right' && player1.direction != 'left'
  player1.new_direction('up') if event.key == 'up' && player1.direction != 'down'
  player1.new_direction('down') if event.key == 'down' && player1.direction != 'up'

  player2.new_direction('left') if event.key == 'a' && player2.direction != 'right'
  player2.new_direction('right') if event.key == 'd' && player2.direction != 'left'
  player2.new_direction('up') if event.key == 'w' && player2.direction != 'down'
  player2.new_direction('down') if event.key == 's' && player2.direction != 'up'

# restarts the game, otherwise the space key just pauses it
  if game.finished? && event.key == 'space'
    p1color = PLAYER_ONE_COLORS.sample
    p2color = PLAYER_TWO_COLORS.sample
    player2 = Snake.new(p1color, 1)
    player1 = Snake.new(p2color, 2) 
    game = Game.new(p1color, p2color)
  end

  close if event.key == 'escape'
  game.pause if event.key =='space'
end
show
