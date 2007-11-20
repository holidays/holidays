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

  def test_date_ranges
    holidays = Holidays.between(Date.civil(2008,1,1), Date.civil(2008,12,31), :au)
    holidays.each do |h|
      #puts h.inspect
    end
    
  end

  def test_easter_dates
    assert_equal '1800-04-13', Holidays.easter(1800).to_s
    assert_equal '1899-04-02', Holidays.easter(1899).to_s
    assert_equal '1900-04-15', Holidays.easter(1900).to_s
    assert_equal '1999-04-04', Holidays.easter(1999).to_s
    assert_equal '2000-04-23', Holidays.easter(2000).to_s
    assert_equal '2025-04-20', Holidays.easter(2025).to_s
    assert_equal '2035-03-25', Holidays.easter(2035).to_s
    assert_equal '2067-04-03', Holidays.easter(2067).to_s
    assert_equal '2099-04-12', Holidays.easter(2099).to_s
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
    assert_equal 1, Date.calculate_mday(2008, 9, :first, 1)
    assert_equal 7, Date.calculate_mday(2009, 9, :first, 1)
    assert_equal 5, Date.calculate_mday(2011, 9, :first, 1)
    assert_equal 5, Date.calculate_mday(2050, 9, :first, 1)
    assert_equal 4, Date.calculate_mday(2051, 9, :first, 1)
    
    # Canadian thanksgiving
    assert_equal 8, Date.calculate_mday(2007, 10, :second, 1)
    assert_equal 13, Date.calculate_mday(2008, 10, :second, 1)
    assert_equal 12, Date.calculate_mday(2009, 10, :second, 1)
    assert_equal 11, Date.calculate_mday(2010, 10, :second, 1)

    # Misc
    assert_equal 21, Date.calculate_mday(2008, 1, :third, 1)
    assert_equal 1, Date.calculate_mday(2007, 1, :first, 1)
    assert_equal 2, Date.calculate_mday(2007, 3, :first, 5)    

  end

  def test_region_params
    holidays = Holidays.by_day(@date, :us)
    assert_equal 1, holidays.length

    holidays = Holidays.by_day(@date, [:us,:ca])
    assert_equal 1, holidays.length
  end

  def test_by_day_spot_checks
    h = Holidays.by_day(Date.civil(2008,5,1), :gr)
    assert_equal 'Labour Day', h[0][:name]

    h = Holidays.by_day(Date.civil(2045,11,1), :fr)
    assert_equal 'Touissant', h[0][:name]
  end

  def test_by_day_and_iterate
    holidays = Holidays.by_day(@date, :ca)
    holidays.each do |h|
      #puts h[:name]
    end
  end

  def test_lookup_holiday
    holidays = Holidays.by_day(Date.civil(2008,1,21), :ca)
    assert_equal 0, holidays.length

    holidays = Holidays.by_day(Date.civil(2008,1,21), :us)
    assert_equal 1, holidays.length
  end

  def test_basic
    assert Date.civil(2008,1,1).is_holiday?('ca')
  end

end
