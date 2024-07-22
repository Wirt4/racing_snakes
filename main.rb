require 'ruby2d'
load 'board.rb'
load 'game_clock.rb'
load 'snake.rb'
load 'settings.rb'
load 'keyboard_buttons.rb'

set background: Settings::BACKGROUND
set width: Settings::WIDTH
set height: Settings::HEIGHT
set fps_cap: Settings::FPS
set fullscreen: Settings::FULLSCREEN

#should be covered by constructor
clock = GameClock.new()
player1_color = Settings::PLAYER_ONE_COLORS.sample
player1 = Snake.new(1, player1_color)
player2_color = Settings::PLAYER_TWO_COLORS.sample
player2 = Snake.new(2, player2_color)
game = Board.new(player1_color, player2_color)

#should be encapsulated by draw_snakes method
player2.draw
player1.draw

# the game cycle
update do
  clear

  #replace with is_paused? method
  unless game.finished? or game.menu?
    #replace with move() method
    game.is_tie(player2, player1)
    player1.move
    player2.move
    clock.increment()
  end

  #replace with draw board method
  player1.draw
  player2.draw
  game.draw
  player1Eats = game.snake_eat_food?(player1)
  player2Eats = game.snake_eat_food?(player2)

  #player_eats
  if player1Eats or player2Eats
    #make method: grow_and_spawn_food
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
    game.drop_shadow(game.winner(player2, player1), Settings::TEXT_COLOR, Settings::WINNER_MSG_X, Settings::WINNER_MSG_Y)
    if game.p1_winner?
      player1.z = Settings::WINNER_Z_NDX
    else
      player2.z = Settings::WINNER_Z_NDX
    end
  end
end

#player controls, is up, down, left, right /AWSD
on :key_down do |event|

  player1.detect_key(event.key)
  player2.detect_key(event.key)

# restarts the game, otherwise the space key just pauses it
  if game.finished? && event.key == Keyboard::SPACE
    player1_color = Settings::PLAYER_ONE_COLORS.sample
    player1 = Snake.new(1, player1_color)
    player2_color = Settings::PLAYER_TWO_COLORS.sample
    player2 = Snake.new(2, player2_color)
    game = Board.new(player1_color, player2_color)
  end

  close if event.key == Keyboard::ESCAPE
  game.pause if event.key ==Keyboard::SPACE
end
show
