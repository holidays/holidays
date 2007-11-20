require File.dirname(__FILE__) + '/test_helper'
require 'date'
# Test cases for reading and generating CSS shorthand properties
class HolidayTests < Test::Unit::TestCase

  def setup
    @date = Date.civil(2008,1,1)
  end

  def test_extending_date_class
    assert @date.respond_to?('is_holiday?')
  end

  def test_calculating_mdays
    assert_equal 21, Holidays.calculate_mday(2008, 1, :third, 1)
    assert_equal 1, Holidays.calculate_mday(2007, 1, :first, 1)
    assert_equal 2, Holidays.calculate_mday(2007, 3, :first, 5)
    assert_equal 25, Holidays.calculate_mday(2008, 5, :last, 1)
    
    
    # Labour day
    assert_equal 3, Holidays.calculate_mday(2007, 9, :first, 1)
    assert_equal 1, Holidays.calculate_mday(2008, 9, :first, 1)
    assert_equal 7, Holidays.calculate_mday(2009, 9, :first, 1)
    assert_equal 5, Holidays.calculate_mday(2011, 9, :first, 1)
    assert_equal 5, Holidays.calculate_mday(2050, 9, :first, 1)
    assert_equal 4, Holidays.calculate_mday(2051, 9, :first, 1)
    
    # Canadian thanksgiving
    assert_equal 8, Holidays.calculate_mday(2007, 10, :second, 1)
    assert_equal 13, Holidays.calculate_mday(2008, 10, :second, 1)
    assert_equal 12, Holidays.calculate_mday(2009, 10, :second, 1)
    assert_equal 11, Holidays.calculate_mday(2010, 10, :second, 1)
    
  end

  def test_region_params
    holidays = Holidays.lookup_holidays(@date, :us)
    assert_equal 1, holidays.length

    holidays = Holidays.lookup_holidays(@date, [:us,:ca])
    assert_equal 1, holidays.length
  end

  def test_lookup_holidays_spot_checks
    h = Holidays.lookup_holidays(Date.civil(2008,5,1), :gr)
    assert_equal 'Labour Day', h[0][:name]

    h = Holidays.lookup_holidays(Date.civil(2045,11,1), :fr)
    assert_equal 'Touissant', h[0][:name]
  end

  def test_lookup_holidays_and_iterate
    holidays = Holidays.lookup_holidays(@date, :ca)
    holidays.each do |h|
      puts h[:name]
    end
  end

  def test_lookup_holiday
    holidays = Holidays.lookup_holidays(Date.civil(2008,1,21), :ca)
    assert_equal 0, holidays.length

    holidays = Holidays.lookup_holidays(Date.civil(2008,1,21), :us)
    assert_equal 1, holidays.length
  end

  def test_basic
    assert Date.civil(2008,1,1).is_holiday?('ca')
  end

end
