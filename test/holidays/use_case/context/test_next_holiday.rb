require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/use_case/context/next_holiday'

class NextHolidayTests < Test::Unit::TestCase
  def setup
    @definition_search = mock()

    @subject = Holidays::UseCase::Context::NextHoliday.new(
      @definition_search,
    )

    @holiday_count = 1
    @from_date= Date.civil(2015, 1, 1)
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

  def test_returns_error_if_holidays_count_is_missing
    assert_raise ArgumentError do
      @subject.call(nil, @from_date, @dates_driver, @regions, @observed, @informal)
    end
  end

  def test_returns_error_if_holidays_count_is_less_than_or_equal_to_zero
    assert_raise ArgumentError do
      @subject.call(0, @from_date, @dates_driver, @regions, @observed, @informal)
    end
  end

  def test_returns_error_if_from_date_is_missing
    assert_raise ArgumentError do
      @subject.call(@holidays_count, nil, @dates_driver, @regions, @observed, @informal)
    end
  end

  def test_returns_error_if_date_driver_is_missing_or_empty
    assert_raise ArgumentError do
      @subject.call(@holidays_count, @from_date, nil, @regions, @observed, @informal)
    end

    assert_raise ArgumentError do
      @subject.call(@holidays_count, @from_date, {}, @regions, @observed, @informal)
    end
  end

  def test_returns_error_if_date_driver_contains_nil_or_empty_months
    bad_dates_driver = {2015 => [0, 1, 2], 2014 => []}

    assert_raise ArgumentError do
      @subject.call(@holidays_count, @from_date, bad_dates_driver, @regions, @observed, @informal)
    end

    bad_dates_driver = {2015 => [0, 1, 2], 2014 => nil}

    assert_raise ArgumentError do
      @subject.call(@holidays_count, @from_date, bad_dates_driver, @regions, @observed, @informal)
    end
  end

  def test_returns_error_if_regions_is_missing_or_empty
    assert_raise ArgumentError do
      @subject.call(@holidays_count, @from_date, @dates_driver, nil, @observed, @informal)
    end

    assert_raise ArgumentError do
      @subject.call(@holidays_count, @from_date, @dates_driver, [], @observed, @informal)
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
      @subject.call(@holiday_count, @from_date, @dates_driver, @regions, @observed, @informal)
    )
  end

  def test_returns_correct_holidays_based_on_holiday_count
    @definition_search.expects(:call).at_most_once.with(
      @dates_driver,
      @regions,
      [],
    ).returns([
      {
        :date => Date.civil(2015, 1, 1),
        :name => "Test",
        :regions => [:us],
      },
      {
        :date => Date.civil(2015, 2, 1),
        :name => "Test",
        :regions => [:us],
      },
      {
        :date => Date.civil(2015, 12, 1),
        :name => "Test",
        :regions => [:us],
      },
      ])

      assert_equal(
        [
          {
            :date => Date.civil(2015, 1, 1),
            :name => "Test",
            :regions => [:us],
          },
          {
            :date => Date.civil(2015, 2, 1),
            :name => "Test",
            :regions => [:us],
          }
        ],
          @subject.call(2, @from_date, @dates_driver, @regions, @observed, @informal)
      )
  end

  def test_returns_correctly_sorted_holidays_based_on_holiday_count_if_holidays_are_out_of_order
    @definition_search.expects(:call).at_most_once.with(
      @dates_driver,
      @regions,
      [],
    ).returns([
      {
        :date => Date.civil(2015, 1, 1),
        :name => "Test",
        :regions => [:us],
      },
      {
        :date => Date.civil(2015, 12, 1),
        :name => "Test",
        :regions => [:us],
      },
      {
        :date => Date.civil(2015, 2, 1),
        :name => "Test",
        :regions => [:us],
      },
      ]
    )

    assert_equal(
      [
        {
          :date => Date.civil(2015, 1, 1),
          :name => "Test",
          :regions => [:us],
        },
        {
          :date => Date.civil(2015, 2, 1),
          :name => "Test",
          :regions => [:us],
        }
      ],
        @subject.call(2, @from_date, @dates_driver, @regions, @observed, @informal)
    )
  end
end
