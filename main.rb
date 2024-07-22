require 'ruby2d'
load 'board.rb'
load 'game_clock.rb'
load 'snake.rb'
load 'settings.rb'
load 'keyboard_buttons.rb'
load 'game.rb'

set background: Settings::BACKGROUND
set width: Settings::WIDTH
set height: Settings::HEIGHT
set fps_cap: Settings::FPS
set fullscreen: Settings::FULLSCREEN

game = Game.new()
game.draw_snakes

# the game cycle
update do
  clear

  unless game.is_paused?
   game.move
  end

  game.draw_board

  if game.player_eats
    game.eat_and_grow
  end

  if game.food_time?
    game.respawn_food
  end

# prints out the winner of the game if it ends
  if game.is_collision?
    game.stop_game
  end
end

#player controls, is up, down, left, right /AWSD
on :key_down do |event|
  k = event.key
  game.detect_key(k)
  close if event.key == Keyboard::ESCAPE
end
show
