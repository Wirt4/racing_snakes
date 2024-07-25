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
    return @tick > random_cutoff_mark
  end

  def random_cutoff_mark()
    return rand_wrapper(300..400)
  end

  def rand_wrapper(range)
    return rand(range)
  end
end
