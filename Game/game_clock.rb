class GameClock
  def initialize()
    @tick =0
  end

  def tick()
    @tick += 1
  end

  def reset()
    @tick =0
  end

  def is_food_time()
    return @tick > 20 * rand(15..20) #need to weed out these magical numbers
  end
end
