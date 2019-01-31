# encoding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

class NonstandardRegionsHolidaysTests < Test::Unit::TestCase
  def test_ecbtarget_christmas_day
    h = Holidays.on(Date.new(2018,12,25), :ecbtarget)
    assert_equal 'Christmas Day', h[0][:name]
  end

  # Federal Reserve (Board of Governors):
  #
  #   * If the holiday falls on a Saturday, it is observed on Friday
  #   * If the holiday falls on a Sunday, it is observed on Monday
  #
  # Source: http://www.federalreserve.gov/aboutthefed/k8.htm
  def test_federalreserve_memorial_day
    h = Holidays.on(Date.new(2021, 1, 1), :federalreserve)
    assert_equal "New Year's Day", h[0][:name]

    h = Holidays.on(Date.new(2021, 7, 5), :federalreserve, :observed)  # 2021-07-04 is a Sunday, observed on Monday
    assert_equal 'Independence Day', h[0][:name]

    h = Holidays.on(Date.new(2021, 12, 24), :federalreserve, :observed)  # 2021-12-25 is a Saturday, observed on Friday
    assert_equal 'Christmas Day', h[0][:name]
  end

  # Federal Reserve Banks and Branches:
  #
  #   * If the holiday falls on a Saturday, it is not observed
  #   * If the holiday falls on a Sunday, it is observed on Monday
  #
  # Source: http://www.federalreserve.gov/aboutthefed/k8.htm
  def test_federalreservebanks_independence_day
    h = Holidays.on(Date.new(2021, 1, 1), :federalreservebanks)
    assert_equal "New Year's Day", h[0][:name]

    h = Holidays.on(Date.new(2021, 7, 5), :federalreservebanks, :observed)  # 2021-07-04 is a Sunday, observed on Monday
    assert_equal 'Independence Day', h[0][:name]

    h = Holidays.on(Date.new(2021, 12, 24), :federalreservebanks, :observed)  # 2021-12-25 is a Saturday, not observed
    assert_empty h
  end

  def test_unitednations_international_day_of_families
    h = Holidays.on(Date.new(2021,5,15), :unitednations)
    assert_equal 'International Day of Families', h[0][:name]
  end
end
