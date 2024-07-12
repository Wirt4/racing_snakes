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




tick = 0 # count for tracking game time and respawning food if no effect
p1color = PLAYER_ONE_COLORS.sample
p2color = PLAYER_TWO_COLORS.sample
#twoPlayers = false
player2 = Snake.new(p1color, 2) 
player1 = Snake.new(p2color, 1)
game = Game.new(p1color, p2color)
player2.draw 
player1.draw

# the game cycle
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
