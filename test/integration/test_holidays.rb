# encoding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

require "#{Holidays::DEFINITIONS_PATH}/ca"

# Re-include CA defs via holidays/north_america to ensure that individual
# defs aren't duplicated.
require "#{Holidays::DEFINITIONS_PATH}/north_america"

class HolidaysTests < Test::Unit::TestCase
  def setup
    @date = Date.civil(2008,1,1)
  end

  def test_on
    h = Holidays.on(Date.civil(2008,9,1), :ca)
    assert_equal 'Labour Day', h[0][:name]

    holidays = Holidays.on(Date.civil(2008,7,4), :ca)
    assert_equal 0, holidays.length
  end

  def test_any_holidays_during_work_week
    ## Full weeks:
    # Try with a Monday
    assert Holidays.any_holidays_during_work_week?(Date.civil(2012,1,23), :us)
    # Try with a Wednesday
    assert Holidays.any_holidays_during_work_week?(Date.civil(2012,1,25), :us)
    # Try Sunday on a week going into a new month
    assert Holidays.any_holidays_during_work_week?(Date.civil(2012,1,29), :us)
    # Try Wednesday on a week going into a new month
    assert Holidays.any_holidays_during_work_week?(Date.civil(2012,2,1), :us)

    ## Weeks with holidays:
    # New Year's 2012 (on Sunday, observed Monday). Test from a Wednesday.
    assert_equal(false, Holidays.any_holidays_during_work_week?(Date.civil(2012,1,4), :us))
    # Ignore observed holidays with :no_observed
    assert Holidays.any_holidays_during_work_week?(Date.civil(2012,1,4), :us, :no_observed)
    # Labor Day 2012 should be Sept 3
    assert_equal(false, Holidays.any_holidays_during_work_week?(Date.civil(2012,9,5), :us))
    # Should be 10 non-full weeks in the year (in the US)
    weeks_in_2012 = Date.commercial(2013, -1).cweek
    holidays_in_2012 = weeks_in_2012.times.count { |week| Holidays.any_holidays_during_work_week?(Date.commercial(2012,week+1), :us) == false }
    assert_equal 10, holidays_in_2012
  end

  def test_requires_valid_regions
    assert_raises Holidays::InvalidRegion do
      Holidays.on(Date.civil(2008,1,1), :xx)
    end

    assert_raises Holidays::InvalidRegion do
      Holidays.on(Date.civil(2008,1,1), [:ca,:xx])
    end

    assert_raises Holidays::InvalidRegion do
      Holidays.between(Date.civil(2008,1,1), Date.civil(2008,12,31), [:ca,:xx])
    end
  end

  def test_requires_valid_regions_holiday_next
    assert_raises Holidays::InvalidRegion do
      Holidays.next_holidays(1, [:xx], Date.civil(2008,1,1))
    end

    assert_raises Holidays::InvalidRegion do
      Holidays.next_holidays(1, [:ca,:xx], Date.civil(2008,1,1))
      Holidays.on(Date.civil(2008,1,1), [:ca,:xx])
    end

    assert_raises Holidays::InvalidRegion do
      Holidays.next_holidays(1, [:ca,:xx])
    end
  end

  def test_region_params
    holidays = Holidays.on(@date, :ca)
    assert_equal 1, holidays.length

    holidays = Holidays.on(@date, [:ca_bc,:ca])
    assert_equal 1, holidays.length
  end

  def test_observed_dates
    # Should fall on Tuesday the 1st
   assert_equal 1, Holidays.on(Date.civil(2008,7,1), :ca, :observed).length

    # Should fall on Monday the 2nd
    assert_equal 1, Holidays.on(Date.civil(2007,7,2), :ca, :observed).length
  end

  def test_any_region
    # Should return Victoria Day.
    holidays = Holidays.between(Date.civil(2008,5,1), Date.civil(2008,5,31), :ca)
    assert_equal 1, holidays.length

    # Should return Victoria Day and National Patriotes Day.
    #
    # Should be 2 in the CA region but other regional files are loaded during the
    # unit tests add to the :any count.
    holidays = Holidays.between(Date.civil(2008,5,1), Date.civil(2008,5,31), [:any])
    assert holidays.length >= 2

    # Test blank region
    holidays = Holidays.between(Date.civil(2008,5,1), Date.civil(2008,5,31))
    assert holidays.length >= 3
  end

  def test_any_region_holiday_next
    # Should return Victoria Day.
    holidays = Holidays.next_holidays(1, [:ca], Date.civil(2008,5,1))
    assert_equal 1, holidays.length
    assert_equal ['2008-05-19','Victoria Day'] , [holidays.first[:date].to_s, holidays.first[:name].to_s]

    # Should return 2 holidays.
    holidays = Holidays.next_holidays(2, [:ca], Date.civil(2008,5,1))
    assert_equal 2, holidays.length

    # Should return 1 holiday in July
    holidays = Holidays.next_holidays(1, [:jp], Date.civil(2016, 5, 22))
    assert_equal ['2016-07-18','海の日'] , [holidays.first[:date].to_s, holidays.first[:name].to_s]

    # Must Region.If there is not region, raise ArgumentError.
    assert_raises ArgumentError do
      Holidays.next_holidays(2, '', Date.civil(2008,5,1))
    end
    # Options should be present.If they are empty, raise ArgumentError.
    assert_raises ArgumentError do
      Holidays.next_holidays(2, [], Date.civil(2008,5,1))
    end
    # Options should be Array.If they are not Array, raise ArgumentError.
    assert_raises ArgumentError do
      Holidays.next_holidays(2, :ca, Date.civil(2008,5,1))
    end
  end

  def test_year_holidays
    # Should return 9 holidays from February 23 to December 31
    holidays = Holidays.year_holidays([:ca_on], Date.civil(2016, 2, 23))
    assert_equal 9, holidays.length

    # Must have options (Regions)
    assert_raises ArgumentError do
      Holidays.year_holidays([], Date.civil(2016, 2, 23))
    end

    # Options must be in the form of an array.
    assert_raises ArgumentError do
      Holidays.year_holidays(:ca_on, Date.civil(2016, 2, 23))
    end
  end

  def test_year_holidays_with_specified_year
    # Should return all 11 holidays for 2016 in Ontario, Canada
    holidays = Holidays.year_holidays([:ca_on], Date.civil(2016, 1, 1))
    assert_equal 11, holidays.length

    # Should return all 5 holidays for 2016 in Australia (most holidays now differ by state)
    holidays = Holidays.year_holidays([:au], Date.civil(2016, 1, 1))
    assert_equal 5, holidays.length
  end

  def test_year_holidays_without_specified_year
    # Gets holidays for current year from today's date
    holidays = Holidays.year_holidays([:ca_on])
    assert_equal holidays.first[:date].year, Date.today.year
  end

  def test_year_holidays_feb_29_on_non_leap_year
    assert_raises ArgumentError do
      Holidays.year_holidays([:ca_on], Date.civil(2015, 2, 29))
    end

    assert_raises ArgumentError do
      Holidays.year_holidays([:ca_on], Date.civil(2019, 2, 29))
    end

    assert_raises ArgumentError do
      Holidays.year_holidays([:ca_on], Date.civil(2021, 2, 29))
    end

    assert_raises ArgumentError do
      Holidays.year_holidays([:us], Date.civil(2023, 2, 29))
    end

    assert_raises ArgumentError do
      Holidays.year_holidays([:ca_on], Date.civil(2025, 2, 29))
    end
  end

  def test_year_holidays_random_years
    # Should be 1 less holiday, as Family day didn't exist in Ontario in 1990
    holidays = Holidays.year_holidays([:ca_on], Date.civil(1990, 1, 1))
    assert_equal 10, holidays.length

    # Family day still didn't exist in 2000
    holidays = Holidays.year_holidays([:ca_on], Date.civil(2000, 1, 1))
    assert_equal 10, holidays.length

    holidays = Holidays.year_holidays([:ca_on], Date.civil(2020, 1, 1))
    assert_equal 11, holidays.length

    holidays = Holidays.year_holidays([:ca_on], Date.civil(2050, 1, 1))
    assert_equal 11, holidays.length

    holidays = Holidays.year_holidays([:jp], Date.civil(2070, 1, 1))
    assert_equal 18, holidays.length
  end

  def test_sub_regions
    # Should return Victoria Day.
    holidays = Holidays.between(Date.civil(2008,5,1), Date.civil(2008,5,31), :ca)
    assert_equal 1, holidays.length

    # Should return Victoria Da and National Patriotes Day.
    holidays = Holidays.between(Date.civil(2008,5,1), Date.civil(2008,5,31), :ca_qc)
    assert_equal 2, holidays.length

    # Should return Victoria Day and National Patriotes Day.
    holidays = Holidays.between(Date.civil(2008,5,1), Date.civil(2008,5,31), :ca_)
    assert_equal 2, holidays.length
  end

  def test_sub_regions_holiday_next
    # Should return Victoria Day.
    holidays = Holidays.next_holidays(2, [:ca], Date.civil(2008,5,1))
    assert_equal 2, holidays.length
    assert_equal ['2008-05-19','Victoria Day'] , [holidays.first[:date].to_s, holidays.first[:name].to_s]

    # Should return Victoria Da and National Patriotes Day.
    holidays = Holidays.next_holidays(2, [:ca_qc], Date.civil(2008,5,1))
    assert_equal 2, holidays.length
    assert_equal ['2008-05-19','Victoria Day'] , [holidays.first[:date].to_s, holidays.first[:name].to_s]
    assert_equal ['2008-05-19','National Patriotes Day'] , [holidays.last[:date].to_s, holidays.last[:name].to_s]

    # Should return Victoria Day and National Patriotes Day.
    holidays = Holidays.next_holidays(2, [:ca_], Date.civil(2008,5,1))
    assert_equal 2, holidays.length
    assert_equal ['2008-05-19','Victoria Day'] , [holidays.first[:date].to_s, holidays.first[:name].to_s]
    assert_equal ['2008-05-19','National Patriotes Day'] , [holidays.last[:date].to_s, holidays.last[:name].to_s]
  end

  def test_easter_lambda
    [Date.civil(1800,4,11), Date.civil(1899,3,31), Date.civil(1900,4,13),
     Date.civil(2008,3,21), Date.civil(2035,3,23)].each do |date|
      assert_equal 'Good Friday', Holidays.on(date, :ca)[0][:name]
    end

    [Date.civil(1800,4,14), Date.civil(1899,4,3), Date.civil(1900,4,16),
     Date.civil(2008,3,24), Date.civil(2035,3,26)].each do |date|
      assert_equal 'Easter Monday', Holidays.on(date, :ca_qc, :informal)[0][:name]
    end
  end

  def test_sorting
    (1..10).each{|year|
      (1..12).each{|month|
        holidays = Holidays.between(Date.civil(year, month, 1), Date.civil(year, month, 28), :gb_)
        holidays.each_with_index{|holiday, index|
          assert holiday[:date] >= holidays[index - 1][:date] if index > 0
        }
      }
    }
  end

  def test_caching
    start_date = Date.civil(2008, 3, 21)
    end_date = Date.civil(2008, 3, 25)
    cache_data = Holidays.between(start_date, end_date, :ca, :informal)
    options = [:ca, :informal]

    Holidays.cache_between(Date.civil(2008,3,21), Date.civil(2008,3,25), :ca, :informal)

    # Test that correct results are returned outside the cache range, and with no caching
    assert_equal 1, Holidays.on(Date.civil(2035,1,1), :ca, :informal).length
    assert_equal 1, Holidays.on(Date.civil(2035,1,1), :us).length

    Holidays::Factory::Finder.expects(:between).never # Make sure cache is hit for two next call

    # Test that cache has been set and it returns the same as before
    assert_equal 1, Holidays.on(Date.civil(2008, 3, 21), :ca, :informal).length
    assert_equal 1, Holidays.on(Date.civil(2008, 3, 24), :ca, :informal).length
  end

  def test_load_all
    Holidays.load_all
    assert_equal 294, Holidays.available_regions.count
  end
end
