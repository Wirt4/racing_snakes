class Button
  def initialize(player_id)
    if player_id==1
        @left ='left'
        @right = 'right'
        @down ='down'
        @up = 'up'
      return
    end
    @left ='a'
    @right = 'd'
    @down ='s'
    @up = 'w'
  end

  def up
    @up
  end

  def down
    @down
  end

  def left
    @left
  end

  def right
    @right
  end
end
