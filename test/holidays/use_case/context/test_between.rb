require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/use_case/context/between'

class BetweenTests < Test::Unit::TestCase
  def setup
    @definition_search = mock()

    @subject = Holidays::UseCase::Context::Between.new(
      @definition_search,
    )

    @start_date = Date.civil(2015, 1, 1)
    @end_date = Date.civil(2015, 1, 1)
    @dates_driver = {2015 => [0, 1, 2], 2014 => [0, 12]}
    @regions = [:us]
    @observed = false
    @informal = false

    @definition_search.expects(:call).at_most_once.with(
      @dates_driver,
      @regions,
      [],
    ).returns([{
      :date => Date.civil(2015, 1, 1),
      :name => "Test",
      :regions => [:us],
    }])
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

  def test_returns_single_holiday
    assert_equal(
      [
        {
          :date => Date.civil(2015, 1, 1),
          :name => "Test",
          :regions => [:us],
        }
      ],
      @subject.call(@start_date, @end_date, @dates_driver, @regions, @observed, @informal)
    )
  end

  def test_returns_sorted_multiple_holidays
    @start_date = Date.civil(2015, 1, 1)
    @end_date = Date.civil(2016, 12, 31)

    @definition_search.expects(:call).at_most_once.with(
      @dates_driver,
      @regions,
      [],
    ).returns([
      {
        :date => Date.civil(2015, 6, 1),
        :name => "2015-June",
        :regions => [:us],
      },
      {
        :date => Date.civil(2015, 1, 1),
        :name => "2015-Jan",
        :regions => [:us],
      },
      {
        :date => Date.civil(2016, 6, 1),
        :name => "2016-June",
        :regions => [:us],
      },
    ])

    assert_equal(
      [
        {
          :date => Date.civil(2015, 1, 1),
          :name => "2015-Jan",
          :regions => [:us],
        },
        {
          :date => Date.civil(2015, 6, 1),
          :name => "2015-June",
          :regions => [:us],
        },
        {
          :date => Date.civil(2016, 6, 1),
          :name => "2016-June",
          :regions => [:us],
        },
      ],
      @subject.call(@start_date, @end_date, @dates_driver, @regions, @observed, @informal)
    )
  end

  def test_filters_holidays_returned_by_search_if_not_in_date_range
    @start_date = Date.civil(2015, 1, 1)
    @end_date = Date.civil(2015, 12, 31)

    @definition_search.expects(:call).at_most_once.with(
      @dates_driver,
      @regions,
      [],
    ).returns([
      {
        :date => Date.civil(2015, 6, 1),
        :name => "2015-June",
        :regions => [:us],
      },
      {
        :date => Date.civil(2015, 1, 1),
        :name => "2015-Jan",
        :regions => [:us],
      },
      {
        :date => Date.civil(2016, 6, 1),
        :name => "2016-June",
        :regions => [:us],
      },
    ])

    assert_equal(
      [
        {
          :date => Date.civil(2015, 1, 1),
          :name => "2015-Jan",
          :regions => [:us],
        },
        {
          :date => Date.civil(2015, 6, 1),
          :name => "2015-June",
          :regions => [:us],
        },
      ],
      @subject.call(@start_date, @end_date, @dates_driver, @regions, @observed, @informal)
    )
  end
end
