class Game

# initializes with the colors of the players so can print the instructions unopbtrusively
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