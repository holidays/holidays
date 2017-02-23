require File.expand_path(File.dirname(__FILE__)) + '/../../test_helper'

require 'holidays/date_calculator/lunar_date.rb'

class LunarHolidaysCalculatorTests < Test::Unit::TestCase
  def setup
    @subject = Holidays::DateCalculator::LunarDate
  end

  def test_korean_new_year_returns_expected_results
    assert_equal '1994-02-10', @subject.to_solar(1994,1,1).to_s
    assert_equal '1995-01-31', @subject.to_solar(1995,1,1).to_s
    assert_equal '1999-02-16', @subject.to_solar(1999,1,1).to_s
    assert_equal '2000-02-05', @subject.to_solar(2000,1,1).to_s
    assert_equal '2001-01-24', @subject.to_solar(2001,1,1).to_s
    assert_equal '2002-02-12', @subject.to_solar(2002,1,1).to_s
    assert_equal '2008-02-07', @subject.to_solar(2008,1,1).to_s
    assert_equal '2009-01-26', @subject.to_solar(2009,1,1).to_s
    assert_equal '2010-02-14', @subject.to_solar(2010,1,1).to_s
    assert_equal '2014-01-31', @subject.to_solar(2014,1,1).to_s
    assert_equal '2017-01-28', @subject.to_solar(2017,1,1).to_s
    assert_equal '2020-01-25', @subject.to_solar(2020,1,1).to_s
    assert_equal '2022-02-01', @subject.to_solar(2022,1,1).to_s
    assert_equal '2025-01-29', @subject.to_solar(2025,1,1).to_s
  end

  def test_buddahs_birthday_returns_expected_results
    assert_equal '1994-05-18', @subject.to_solar(1994,4,8).to_s
    assert_equal '1995-05-07', @subject.to_solar(1995,4,8).to_s
    assert_equal '1999-05-22', @subject.to_solar(1999,4,8).to_s
    assert_equal '2000-05-11', @subject.to_solar(2000,4,8).to_s
    assert_equal '2001-05-01', @subject.to_solar(2001,4,8).to_s
    assert_equal '2002-05-19', @subject.to_solar(2002,4,8).to_s
    assert_equal '2008-05-12', @subject.to_solar(2008,4,8).to_s
    assert_equal '2009-05-02', @subject.to_solar(2009,4,8).to_s
    assert_equal '2010-05-21', @subject.to_solar(2010,4,8).to_s
    assert_equal '2014-05-06', @subject.to_solar(2014,4,8).to_s
    assert_equal '2017-05-03', @subject.to_solar(2017,4,8).to_s
    assert_equal '2020-04-30', @subject.to_solar(2020,4,8).to_s
    assert_equal '2022-05-08', @subject.to_solar(2022,4,8).to_s
    assert_equal '2025-05-05', @subject.to_solar(2025,4,8).to_s
  end

  def test_korean_thanksgiving_returns_expected_results
    assert_equal '1994-09-20', @subject.to_solar(1994,8,15).to_s
    assert_equal '1995-09-09', @subject.to_solar(1995,8,15).to_s
    assert_equal '1999-09-24', @subject.to_solar(1999,8,15).to_s
    assert_equal '2000-09-12', @subject.to_solar(2000,8,15).to_s
    assert_equal '2001-10-01', @subject.to_solar(2001,8,15).to_s
    assert_equal '2002-09-21', @subject.to_solar(2002,8,15).to_s
    assert_equal '2008-09-14', @subject.to_solar(2008,8,15).to_s
    assert_equal '2009-10-03', @subject.to_solar(2009,8,15).to_s
    assert_equal '2010-09-22', @subject.to_solar(2010,8,15).to_s
    assert_equal '2014-09-08', @subject.to_solar(2014,8,15).to_s
    assert_equal '2017-10-04', @subject.to_solar(2017,8,15).to_s
    assert_equal '2020-10-01', @subject.to_solar(2020,8,15).to_s
    assert_equal '2022-09-10', @subject.to_solar(2022,8,15).to_s
    assert_equal '2025-10-06', @subject.to_solar(2025,8,15).to_s
  end
end
