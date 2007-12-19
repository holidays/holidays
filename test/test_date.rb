require File.dirname(__FILE__) + '/test_helper'

class DateTests < Test::Unit::TestCase
  def setup
    @date = Date.civil(2008,1,1)
  end

  def test_extending_date_class
    assert @date.respond_to?('holiday?')
    assert @date.respond_to?('holiday?')
  end

  def test_calculating_mdays
    # US Memorial day
    assert_equal 29, Date.calculate_mday(2006, 5, :last, 1)
    assert_equal 28, Date.calculate_mday(2007, 5, :last, 1)
    assert_equal 26, Date.calculate_mday(2008, 5, :last, 1)
    assert_equal 25, Date.calculate_mday(2009, 5, :last, 1)
    assert_equal 31, Date.calculate_mday(2010, 5, :last, 1)
    assert_equal 30, Date.calculate_mday(2011, 5, :last, 1)
    
    # Labour day
    assert_equal 3, Date.calculate_mday(2007, 9, :first, 1)
    assert_equal 1, Date.calculate_mday(2008, 9, :first, :monday)
    assert_equal 7, Date.calculate_mday(2009, 9, :first, 1)
    assert_equal 5, Date.calculate_mday(2011, 9, :first, 1)
    assert_equal 5, Date.calculate_mday(2050, 9, :first, 1)
    assert_equal 4, Date.calculate_mday(2051, 9, :first, 1)
    
    # Canadian thanksgiving
    assert_equal 8, Date.calculate_mday(2007, 10, :second, 1)
    assert_equal 13, Date.calculate_mday(2008, 10, :second, :monday)
    assert_equal 12, Date.calculate_mday(2009, 10, :second, 1)
    assert_equal 11, Date.calculate_mday(2010, 10, :second, 1)

    # Misc
    assert_equal 21, Date.calculate_mday(2008, 1, :third, 1)
    assert_equal 1, Date.calculate_mday(2007, 1, :first, 1)
    assert_equal 2, Date.calculate_mday(2007, 3, :first, :friday)
  end

  def test_mday_allows_integers_or_symbols
    assert_nothing_raised do
      Date.calculate_mday(2008, 1, 1, 1)
    end

    assert_nothing_raised do
      Date.calculate_mday(2008, 1, -1, 1)
    end

    assert_nothing_raised do
      Date.calculate_mday(2008, 1, :last, 1)
    end
  end

  def test_mday_requires_valid_week
    assert_raises ArgumentError do
      Date.calculate_mday(2008, 1, :none, 1)
    end

    assert_raises ArgumentError do
      Date.calculate_mday(2008, 1, nil, 1)
    end

    assert_raises ArgumentError do
      Date.calculate_mday(2008, 1, 0, 1)
    end
  end

  def test_mday_requires_valid_day
    assert_raises ArgumentError do
      Date.calculate_mday(2008, 1, 1, :october)
    end

    assert_raises ArgumentError do
      Date.calculate_mday(2008, 1, 1, nil)
    end

    assert_raises ArgumentError do
      Date.calculate_mday(2008, 1, 1, 7)
    end
  end

  def test_holiday?
    assert Date.civil(2008,1,1).holiday?('ca')
  end
end
