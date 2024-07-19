require 'ruby2d'

load 'Game/game.rb'
load 'Game/game_clock.rb'
load 'snake.rb'
load 'settings.rb'

set background: Settings::BACKGROUND
set width: Settings::WIDTH
set height: Settings::HEIGHT
set fps_cap: Settings::FPS
set fullscreen: Settings::FULLSCREEN

GRID_SIZE = 30
GRID_WIDTH = Window.width/GRID_SIZE
GRID_HEIGHT = Window.height/GRID_SIZE
NODE_SIZE = GRID_SIZE

GAME_TITLE = 'SNAKE RACE'
PROMPT = 'Turn: '
TEXT_COLOR = 'white'
PLAYER_ONE_KEYS = 'A, W, S, D'
PLAYER_TWO_KEYS = 'Arrow Keys'


clock = GameClock.new()

player1 = Snake.new(1)
player2 = Snake.new(2)

game = Game.new(player1.color, player2.color)
player2.draw
player1.draw



# the game cycle
update do
  clear

  unless game.finished? or game.menu?
    game.tie(game.is_tie?(player2, player1))
    player1.move
    player2.move
    clock.increment()
  end
  player1.draw
  player2.draw
  game.draw

  player1Eats = game.snake_eat_food?(player1.x, player1.y)
  player2Eats = game.snake_eat_food?(player2.x, player2.y)

  if player1Eats or player2Eats
    if player1Eats
      player1.grow
    else
      player2.grow
    end
    game.respawn_food(player2.position + player1.position)
    clock.reset()
  end

# randomises the food appearences between 15 and 20 seconds since game start or last food eats
  if clock.is_food_time()
    clock.reset()
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

  player1.detect_key(event.key)
  player2.detect_key(event.key)

# restarts the game, otherwise the space key just pauses it
  if game.finished? && event.key == 'space'
    player2 = Snake.new(1)
    player1 = Snake.new(2)
    game = Game.new(player1.color, player2.color)
  end

  close if event.key == 'escape'
  game.pause if event.key =='space'
end
show
