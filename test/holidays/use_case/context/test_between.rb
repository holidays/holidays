require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/use_case/context/between'

#TODO These tests need love. This is the heart of the holiday logic and I'm only
# now starting to tear bits and pieces of it apart to untangle it. This is a start
# but definitely needs more coverage.
class BetweenTests < Test::Unit::TestCase
  def setup
    @holidays_by_month_repo = mock()
    @day_of_month_calculator = mock()
    @custom_method_repo = mock()
    @proc_cache_repo = mock()

    @subject = Holidays::UseCase::Context::Between.new(
      @holidays_by_month_repo,
      @day_of_month_calculator,
      @custom_method_repo,
      @proc_cache_repo,
    )

    @start_date = Date.civil(2015, 1, 1)
    @end_date = Date.civil(2015, 1, 1)
    @dates_driver = {2015 => [0, 1, 2], 2014 => [0, 12]}
    @regions = [:us]
    @observed = false
    @informal = false
  end

  def test_returns_error_if_start_date_is_missing
    assert_raise ArgumentError do
      @subject.call(nil, @end_date, @dates_driver, @regions, @observed, @informal)
    end
  end

  def test_returns_error_if_end_date_is_missing
    assert_raise ArgumentError do
      @subject.call(@start_date, nil, @dates_driver, @regions, @observed, @informal)
    end
  end

  def test_returns_error_if_driver_hash_is_nil
    assert_raise ArgumentError do
      @subject.call(@start_date, @end_date, nil, @regions, @observed, @informal)
    end
  end

  def test_returns_error_if_driver_hash_is_empty
    assert_raise ArgumentError do
      @subject.call(@start_date, @end_date, {}, @regions, @observed, @informal)
    end
  end

  def test_returns_error_if_driver_hash_has_empty_months_array
    assert_raise ArgumentError do
      @subject.call(@start_date, @end_date, {2015 => nil}, @regions, @observed, @informal)
    end

    assert_raise ArgumentError do
      @subject.call(@start_date, @end_date, {2015 => []}, @regions, @observed, @informal)
    end

    assert_raise ArgumentError do
      @subject.call(@start_date, @end_Date, {2015 => [1], 2016 => [1], 2017 => []}, @regions, @observed, @informal)
    end
  end

  def test_returns_error_if_regions_are_missing_or_empty
    assert_raise ArgumentError do
      @subject.call(@start_date, @end_date, @dates_driver, nil, @observed, @informal)
    end

    assert_raise ArgumentError do
      @subject.call(@start_date, @end_date, @dates_driver, [], @observed, @informal)
    end
  end
end
