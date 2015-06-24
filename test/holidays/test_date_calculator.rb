require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

require 'holidays/date_calculator'

class DateCalculatorTests < Test::Unit::TestCase
  def setup
    @subject = Holidays::DateCalculator
  end

  def test_calculate_easter_for
    assert @subject.calculate_easter_for(1800).is_a?(Date)
  end

  def test_calculate_orthodox_easter_for_returns_a_date
    assert @subject.calculate_orthodox_easter_for(1800).is_a?(Date)
  end

  def test_to_weekday_if_weekend
    assert @subject.to_weekday_if_weekend(Date.civil(2015, 4, 1)).is_a?(Date)
  end

  def test_to_weekday_if_boxing_weekend
    assert @subject.to_weekday_if_boxing_weekend(Date.civil(2015, 4, 1)).is_a?(Date)
  end

  def test_to_monday_if_weekend
    assert @subject.to_monday_if_weekend(Date.civil(2015, 4, 1)).is_a?(Date)
  end

  def test_to_monday_if_sunday
    assert @subject.to_monday_if_sunday(Date.civil(2015, 4, 1)).is_a?(Date)
  end

  def test_day_of_month
    assert @subject.day_of_month(2008, 1, :first, 6)
  end
end
