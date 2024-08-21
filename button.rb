class Button
  def initialize(player_id)
    if player_id==PlayerIds::PLAYER_ONE
        @left ='o'
        @right = 'p'
      return
    end
    @left ='q'
    @right = 'w'
  end

  def left
    @left
  end

  def right
    @right
  end
end
