require File.expand_path(File.dirname(__FILE__)) + '/../../test_helper'

require 'holidays/date_calculator/hijri_date.rb'

class HijriDateCalculatorTests < Test::Unit::TestCase
  def setup
    @subject = Holidays::DateCalculator::HijriDate.new
  end

  def test_to_gregorian_converts_known_reference_dates
    assert_equal '2014-10-25', @subject.to_gregorian(1436, 1, 1).to_s
    assert_equal '2019-05-06', @subject.to_gregorian(1440, 9, 1).to_s
    assert_equal '2023-04-22', @subject.to_gregorian(1444, 10, 1).to_s
    assert_equal '2025-06-07', @subject.to_gregorian(1446, 12, 10).to_s
    assert_equal '2033-04-01', @subject.to_gregorian(1455, 1, 1).to_s
  end

  def test_gregorian_year_occurrence_returns_the_date_in_that_year
    assert_equal '2023-04-22', @subject.gregorian_year_occurrence(2023, 10, 1).to_s
    assert_equal '2032-01-14', @subject.gregorian_year_occurrence(2032, 10, 1).to_s
    assert_equal '2031-04-03', @subject.gregorian_year_occurrence(2031, 12, 10).to_s
  end

  def test_gregorian_year_occurrence_returns_the_earlier_of_two_in_one_year
    # 1 Shawwal falls on both 2033-01-03 and 2033-12-23.
    assert_equal '2033-01-03', @subject.gregorian_year_occurrence(2033, 10, 1).to_s
  end
end
