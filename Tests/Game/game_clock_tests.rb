require 'test/unit'
require '../../Game/game_clock.rb'


#does the out of the box test not like mocking?
class MyTest < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

  def test_init
    clock = GameClock.new()
    assert_equal(clock.tick, 0, "clock should be zero on initiation")
  end

  def test_first_clok_tick
    clock = GameClock.new()
    clock.increment()
    assert_equal(clock.tick, 1,"clock should increment")
  end

  def test_start_time
    clock = GameClock.new(42)
    assert_equal(clock.tick, 42, "clock should initilize to constructor")
  end

  def test_reset
    clock = GameClock.new(31)
    clock.reset()
    assert_equal(clock.tick, 0, "reset should set the clock timer to 0")
  end

  def test_food_time_rand_is_called
    clock = GameClock.new()
    clock.reset()
    assert_equal(clock.tick, 0, "reset should set the clock timer to 0")
  end
end
