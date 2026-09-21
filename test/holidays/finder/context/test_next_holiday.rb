require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/finder/context/next_holiday'

class NextHolidayTests < Test::Unit::TestCase
  def setup
    @regions = [:us]
    @observed = false
    @informal = false

    @definition_search = mock()
    @dates_driver_builder = mock()
    @options_parser = mock()

    @subject = Holidays::Finder::Context::NextHoliday.new(
      @definition_search,
      @dates_driver_builder,
      @options_parser,
    )

    @holiday_count = 1
    @from_date= Date.civil(2015, 1, 1)
    @dates_driver = {2015 => [0, 1, 2], 2014 => [0, 12]}
    @options = [@regions, @observed, @informal]

    @definition_search.expects(:call).at_most_once.with(
      @dates_driver,
      @regions,
      [],
    ).returns([{
      :date => Date.civil(2015, 1, 1),
      :name => "Test",
      :regions => [:us],
    }])

    @dates_driver_builder.expects(:call).at_most_once.with(
      @from_date, @from_date >> 12,
    ).returns(
      @dates_driver,
    )

    @options_parser.expects(:call).at_most_once.with(@options).returns(@options)
  end

  def test_returns_error_if_holidays_count_is_missing
    assert_raise ArgumentError do
      @subject.call(nil, @from_date, @options)
    end
  end

  def test_returns_error_if_holidays_count_is_less_than_or_equal_to_zero
    assert_raise ArgumentError do
      @subject.call(0, @from_date, @options)
    end
  end

  def test_returns_error_if_from_date_is_missing
    assert_raise ArgumentError do
      @subject.call(@holiday_count, nil, @options)
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
      @subject.call(@holiday_count, @from_date, @options)
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
          @subject.call(2, @from_date, @options)
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
        @subject.call(2, @from_date, @options)
    )
  end

  def test_widens_the_search_window_until_the_holiday_count_is_reached
    first_driver = {2015 => [1]}
    second_driver = {2016 => [1]}

    @dates_driver_builder.expects(:call).with(@from_date, @from_date >> 12).returns(first_driver)
    @dates_driver_builder.expects(:call).with((@from_date >> 12) + 1, @from_date >> 24).returns(second_driver)

    @definition_search.expects(:call).with(first_driver, @regions, []).returns([
      {:date => Date.civil(2015, 6, 1), :name => "First", :regions => [:us]},
    ])
    @definition_search.expects(:call).with(second_driver, @regions, []).returns([
      {:date => Date.civil(2016, 3, 1), :name => "Third", :regions => [:us]},
      {:date => Date.civil(2016, 2, 1), :name => "Second", :regions => [:us]},
    ])

    assert_equal(
      %w[First Second Third],
      @subject.call(3, @from_date, @options).map { |h| h[:name] },
    )
  end

  def test_ignores_holidays_past_the_end_of_the_search_window
    first_driver = {2015 => [1]}
    second_driver = {2016 => [1]}

    @dates_driver_builder.expects(:call).with(@from_date, @from_date >> 12).returns(first_driver)
    @dates_driver_builder.expects(:call).with((@from_date >> 12) + 1, @from_date >> 24).returns(second_driver)

    # The first window is only trustworthy up to its end date. Anything the search
    # returns beyond that (e.g. holidays computed for the whole year) is dropped so
    # it is not counted twice or ranked ahead of holidays the window never searched.
    @definition_search.expects(:call).with(first_driver, @regions, []).returns([
      {:date => Date.civil(2015, 6, 1), :name => "First", :regions => [:us]},
      {:date => Date.civil(2016, 5, 29), :name => "Too Early", :regions => [:us]},
    ])
    @definition_search.expects(:call).with(second_driver, @regions, []).returns([
      {:date => Date.civil(2016, 5, 1), :name => "Second", :regions => [:us]},
      {:date => Date.civil(2016, 5, 29), :name => "Third", :regions => [:us]},
    ])

    assert_equal(
      %w[First Second Third],
      @subject.call(3, @from_date, @options).map { |h| h[:name] },
    )
  end

  def test_gives_up_after_searching_fifty_years
    driver = {2015 => [1]}

    @dates_driver_builder.expects(:call).times(50).returns(driver)
    @definition_search.expects(:call).times(50).with(driver, @regions, []).returns([])

    assert_equal([], @subject.call(@holiday_count, @from_date, @options))
  end

  def test_searches_each_window_from_the_original_from_date
    from_date = Date.civil(2024, 2, 29)
    drivers = [{2024 => [2]}, {2025 => [3]}, {2026 => [3]}]

    @options_parser.expects(:call).with(@options).returns(@options)
    @dates_driver_builder.expects(:call).with(from_date, Date.civil(2025, 2, 28)).returns(drivers[0])
    @dates_driver_builder.expects(:call).with(Date.civil(2025, 3, 1), Date.civil(2026, 2, 28)).returns(drivers[1])
    @dates_driver_builder.expects(:call).with(Date.civil(2026, 3, 1), Date.civil(2027, 2, 28)).returns(drivers[2])

    @definition_search.expects(:call).with(drivers[0], @regions, []).returns([])
    @definition_search.expects(:call).with(drivers[1], @regions, []).returns([])
    @definition_search.expects(:call).with(drivers[2], @regions, []).returns([
      {:date => Date.civil(2026, 5, 1), :name => "Found", :regions => [:us]},
    ])

    assert_equal(
      ["Found"],
      @subject.call(@holiday_count, from_date, @options).map { |h| h[:name] },
    )
  end
end
