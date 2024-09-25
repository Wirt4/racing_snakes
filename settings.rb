load 'colors.rb'
module Settings
  WIDTH ||= 1920
  HEIGHT ||= 1080
  FPS ||= 20
  FULLSCREEN ||= true
  BACKGROUND ||= 'black'
  SQUARE_SIZE ||= 30
  TEXT_COLOR ||= 'white'
  FOOD_COLOR ||= TEXT_COLOR
  WINNER_MSG_X ||= 70
  WINNER_MSG_Y ||= 350
  WINNER_Z_NDX ||= 5
  GRID_SIZE ||= SQUARE_SIZE
  GRID_WIDTH ||= WIDTH/GRID_SIZE
  GRID_HEIGHT ||= HEIGHT/GRID_SIZE
  NODE_SIZE ||= GRID_SIZE
  PLAYER_ONE_COLORS ||= [Colors::YELLOW, Colors::ORANGE, Colors::RED, ]
  PLAYER_TWO_COLORS ||= [Colors::FUCHSIA, Colors::BLUE, Colors::GREEN, ]
  START_Y_TAIL ||= 3
  START_LENGTH ||= 3
  PRESS_SPACE ||= '(press space)'
  TIE_MESSAGE ||= 'Tie'
  WINNER_MESSAGE ||= ' Wins'
end
