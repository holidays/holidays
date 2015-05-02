require File.expand_path(File.dirname(__FILE__)) + '/../../test_helper'

require 'holidays/date_calculator/weekend_modifier'

class WeekendModifierDateCalculatorTests < Test::Unit::TestCase
  def setup
    @subject = Holidays::DateCalculator::WeekendModifier.new
  end

  def test_to_monday_if_weekend
    assert_equal Date.civil(2015, 5, 4), @subject.to_monday_if_weekend(Date.civil(2015, 5, 3))
    assert_equal Date.civil(2015, 5, 4), @subject.to_monday_if_weekend(Date.civil(2015, 5, 2))
  end

  def test_to_monday_if_sunday
    assert_equal Date.civil(2015, 5, 4), @subject.to_monday_if_sunday(Date.civil(2015, 5, 3))
  end

  def test_to_weekday_if_boxing_weekend
    assert_equal Date.civil(2015, 5, 4), @subject.to_weekday_if_boxing_weekend(Date.civil(2015, 5, 2))
    assert_equal Date.civil(2015, 5, 5), @subject.to_weekday_if_boxing_weekend(Date.civil(2015, 5, 3))
    assert_equal Date.civil(2015, 5, 5), @subject.to_weekday_if_boxing_weekend(Date.civil(2015, 5, 4))
  end

  def test_to_weekday_if_weekend
    assert_equal Date.civil(2015, 5, 4), @subject.to_weekday_if_weekend(Date.civil(2015, 5, 3))
    assert_equal Date.civil(2015, 5, 1), @subject.to_weekday_if_weekend(Date.civil(2015, 5, 2))
  end
end
