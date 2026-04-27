require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/finder/context/search'

class FinderSearchTests < Test::Unit::TestCase
  def setup
    @holidays_by_month_repo = mock()
    @custom_method_processor = mock()
    @day_of_month_calculator = mock()

    @in_region_rule = mock()
    @year_range_rule = mock()
    @rules = {:in_region => @in_region_rule, :year_range => @year_range_rule}

    @custom_method_repo = mock()
    @proc_cache_repo = mock()

    @start_date = Date.civil(2015, 1, 1)
    @end_date = Date.civil(2015, 1, 1)
    @dates_driver = {2015 => [1]}
    @regions = [:us]
    @options = []

    @holidays_by_month_repo.expects(:find_by_month).at_most_once.returns([:mday => 1, :name => "Test", :regions=>@regions])
    @in_region_rule.expects(:call).at_most_once.returns(true)
    @year_range_rule.expects(:call).at_most_once.returns(false)

    @subject = Holidays::Finder::Context::Search.new(
      @holidays_by_month_repo,
      @custom_method_processor,
      @day_of_month_calculator,
      @rules,
    )
  end

  def test_raises_error_if_dates_driver_is_empty
    @dates_driver = {}
    assert_raises ArgumentError do
      @subject.call(@dates_driver, @regions, @options)
    end
  end

  def test_raises_error_if_dates_driver_contains_bad_month
    @dates_driver = {2015 => [100]}
    assert_raises ArgumentError do
      @subject.call(@dates_driver, @regions, @options)
    end
  end

  def test_raises_error_if_dates_driver_contains_bad_month_mixed_with_valid_months
    @dates_driver = {2015 => [1, 12], 2020 => [1, 200]}
    assert_raises ArgumentError do
      @subject.call(@dates_driver, @regions, @options)
    end
  end

  def test_returns_nothing_if_holidays_repo_returns_nil
    @holidays_by_month_repo.expects(:find_by_month).with(1).returns(nil)
    assert_equal([], @subject.call(@dates_driver, @regions, @options))
  end

  def test_returns_nothing_if_holidays_repo_returns_empty_array
    @holidays_by_month_repo.expects(:find_by_month).with(1).returns([])
    assert_equal([], @subject.call(@dates_driver, @regions, @options))
  end

  def test_returns_nothing_if_holidays_not_in_region
    @holidays_by_month_repo.expects(:find_by_month).returns([:regions=>[:other_region]])
    @in_region_rule.expects(:call).with(@regions, [:other_region]).returns(false)
    assert_equal([], @subject.call(@dates_driver, @regions, @options))
  end

  def test_returns_nothing_if_only_informal_holidays_are_returned_and_no_informal_flag_set
    @holidays_by_month_repo.expects(:find_by_month).returns([:type => :informal, :regions=>@regions])
    assert_equal([], @subject.call(@dates_driver, @regions, @options))
  end

  def test_year_rule_set_but_not_in_required_years_returns_nothing
    @holidays_by_month_repo.expects(:find_by_month).at_most_once.returns([:mday => 1, :name => "Test", :regions=>@regions, :year_ranges => [:after => 2000]])
    assert_equal([], @subject.call(@dates_driver, @regions, @options))
  end

  def test_function_present_returns_date
    @holidays_by_month_repo.expects(:find_by_month).at_most_once.returns([:mday => 1, :name => "Test", :regions=> @regions, :function => "func-id", :function_arguments => [:year], :function_modifier => 1])

    returned_date = Date.civil(2015, 3, 10)
    @custom_method_processor.expects(:call).with(
      {:year => 2015, :month => 1, :day => 1, :region => :us},
      "func-id",
      [:year],
      1,
    ).returns(returned_date)

    assert_equal(
      [{
        :date => Date.civil(2015, 3, 10),
        :name => "Test",
        :regions => [:us],
      }],
       @subject.call(@dates_driver, @regions, @options)
    )
  end

  #FIXME This is a test that reflects how the current system works
  #      but this is NOT valid. See https://github.com/holidays/holidays/issues/204
  def test_function_returns_nil_date_should_not_be_returned
    @holidays_by_month_repo.expects(:find_by_month).at_most_once.returns([:mday => 1, :name => "Test", :regions=> @regions, :function => "func-id", :function_arguments => [:year], :function_modifier => 1])

    @custom_method_processor.expects(:call).with(
      {:year => 2015, :month => 1, :day => 1, :region => :us},
      "func-id",
      [:year],
      1,
    ).returns(nil)

    assert_equal([], @subject.call(@dates_driver, @regions, @options))
  end

  def test_function_not_present_mday_set
    @holidays_by_month_repo.expects(:find_by_month).at_most_once.returns([:mday => 15, :name => "Test", :regions=> @regions])

    assert_equal(
      [{
        :date => Date.civil(2015, 1, 15),
        :name => "Test",
        :regions => [:us],
      }],
       @subject.call(@dates_driver, @regions, @options)
    )
  end

  def test_function_not_present_mday_not_set
    @holidays_by_month_repo.expects(:find_by_month).at_most_once.returns([:name => "Test", :week => 1, :wday => 1, :regions=> @regions])

    @day_of_month_calculator.expects(:call).with(2015, 1, 1, 1).returns(20)

    assert_equal(
      [{
        :date => Date.civil(2015, 1, 20),
        :name => "Test",
        :regions => [:us],
      }],
      @subject.call(@dates_driver, @regions, @options)
    )
  end

  def test_returns_holiday_if_informal_and_informal_flag_set
    @holidays_by_month_repo.expects(:find_by_month).at_most_once.returns([:mday => 13, :name => "Test", :type => :informal, :regions=>@regions])

    assert_equal(
      [{
        :date => Date.civil(2015, 1, 13),
        :name => "Test",
        :regions => [:us],
      }],
      @subject.call(@dates_driver, @regions, [:informal])
    )
  end

  def test_does_not_return_holiday_if_informal_and_informal_flag_not_set
    @holidays_by_month_repo.expects(:find_by_month).at_most_once.returns([:mday => 13, :name => "Test", :type => :informal, :regions=>@regions])

    assert_equal([], @subject.call(@dates_driver, @regions, @options))
  end

  def test_returns_observed_result_if_observed_set_and_observed_function_present
    @holidays_by_month_repo.expects(:find_by_month).at_most_once.returns([:mday => 8, :name => "Test", :type => :observed, :observed => "SOME_OBSERVED_FUNC_ID", :regions=>@regions])

    @custom_method_processor.expects(:call).with(
      {:year => 2015, :month => 1, :day => 8, :region => :us},
      "SOME_OBSERVED_FUNC_ID",
      [:date],
    ).returns(Date.civil(2015, 10, 1))

    assert_equal(
      [{
        :date => Date.civil(2015, 10, 1),
        :name => "Test",
        :regions => [:us],
      }],
      @subject.call(@dates_driver, @regions, [:observed])
    )
  end

  def test_returns_unobserved_date_if_observed_method_not_set_but_flag_is_present
    @holidays_by_month_repo.expects(:find_by_month).at_most_once.returns([:mday => 14, :name => "Test", :type => :observed, :observed => "SOME_OBSERVED_FUNC_ID", :regions=>@regions])

    assert_equal(
      [{
        :date => Date.civil(2015, 1, 14),
        :name => "Test",
        :regions => [:us],
      }],
      @subject.call(@dates_driver, @regions, @options)
    )
  end

  # This is a specific scenario but it COULD happen in our current flow. The goal: any date
  # manipulation that occurs for a specific holiday should have no impact on other holidays.
  def test_returns_expected_result_if_custom_method_modifies_month_when_multiple_holidays_found
    @in_region_rule.expects(:call).twice.returns(true)
    @holidays_by_month_repo.expects(:find_by_month).at_most_once.returns(
      [
        {:mday => 14, :name => "Test", :function => "func-id", :function_arguments => [:year], :regions => @regions},
        {:mday => 14, :name => "Test2", :regions => @regions},
      ]
    )

    @custom_method_processor.expects(:call).with(
      {:year => 2015, :month => 1, :day => 14, :region => :us},
      "func-id",
      [:year],
      nil,
    ).returns(Date.civil(2015, 3, 14))

    assert_equal(
      [
        {
          :date => Date.civil(2015, 3, 14),
          :name => "Test",
          :regions => [:us],
        },
        {
          :date => Date.civil(2015, 1, 14),
          :name => "Test2",
          :regions => [:us],
        }
      ],
      @subject.call(@dates_driver, @regions, @options)
    )
  end

  def test_nil_returned_from_one_region_function_does_not_suppress_valid_result_from_other_region
    two_regions = [:r1, :r2]

    @holidays_by_month_repo.expects(:find_by_month).at_most_once.returns(
      [{ mday: 1, name: "Test", regions: two_regions, function: "func-id", function_arguments: [:year], function_modifier: nil }]
    )
    @in_region_rule.expects(:call).with(two_regions, two_regions).returns(true)

    @custom_method_processor.expects(:call).with(
      { year: 2015, month: 1, day: 1, region: :r1 }, "func-id", [:year], nil,
    ).returns(nil)

    @custom_method_processor.expects(:call).with(
      { year: 2015, month: 1, day: 1, region: :r2 }, "func-id", [:year], nil,
    ).returns(Date.civil(2015, 6, 15))

    result = @subject.call(@dates_driver, two_regions, [])
    assert_equal 1, result.count
    assert_equal Date.civil(2015, 6, 15), result.first[:date]
  end

  def test_conflicting_function_in_two_regions_evaluates_each_independently
    two_regions = [:r1, :r2]

    @holidays_by_month_repo.expects(:find_by_month).at_most_once.returns(
      [{ mday: 1, name: "Test", regions: two_regions, function: "func-id", function_arguments: [:year], function_modifier: nil }]
    )
    @in_region_rule.expects(:call).with(two_regions, two_regions).returns(true)

    @custom_method_processor.expects(:call).with(
      { year: 2015, month: 1, day: 1, region: :r1 }, "func-id", [:year], nil,
    ).returns(Date.civil(2015, 3, 10))

    @custom_method_processor.expects(:call).with(
      { year: 2015, month: 1, day: 1, region: :r2 }, "func-id", [:year], nil,
    ).returns(Date.civil(2015, 6, 15))

    result = @subject.call(@dates_driver, two_regions, [])
    assert_equal 2, result.count
    assert result.any? { |h| h[:date] == Date.civil(2015, 3, 10) }
    assert result.any? { |h| h[:date] == Date.civil(2015, 6, 15) }
  end

  def test_any_region_query_with_function_evaluates_function_exactly_once
    @holidays_by_month_repo.expects(:find_by_month).at_most_once.returns(
      [{ mday: 1, name: "Test", regions: [:r1], function: "func-id", function_arguments: [:year], function_modifier: nil }]
    )
    @in_region_rule.expects(:call).with([:any], [:r1]).returns(true)

    @custom_method_processor.expects(:call).with(
      { year: 2015, month: 1, day: 1, region: :any }, "func-id", [:year], nil,
    ).returns(Date.civil(2015, 3, 10))

    result = @subject.call(@dates_driver, [:any], [])
    assert_equal 1, result.count
    assert_equal Date.civil(2015, 3, 10), result.first[:date]
  end
end
