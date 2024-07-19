class GameClock
  def initialize(startTime=0)
    @tick = startTime
  end

  def increment()
    @tick +=1
  end

  def tick
    @tick
  end

  def reset()
    @tick =0
  end

  def is_food_time()
    return @tick > 20 * rand(15..20) #need to weed out these magical numbers
  end
end
