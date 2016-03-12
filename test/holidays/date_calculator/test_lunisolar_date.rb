require File.expand_path(File.dirname(__FILE__)) + '/../../test_helper'

require 'holidays/date_calculator/lunisolar'

class LunisolarDateCalculatorTests < Test::Unit::TestCase
  def test_lunar_spring_fesival
    spring_first_date = Holidays::DateCalculator::LunisolarDate.to_solar(2016, 1, 1)
    assert_equal(spring_first_date.year, 2016)
    assert_equal(spring_first_date.month, 2)
    assert_equal(spring_first_date.day, 8)
    assert_equal(spring_first_date.class, Date)
  end
end
