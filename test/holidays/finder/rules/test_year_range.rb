require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/finder/rules/year_range'

class FinderRulesYearRangeTests < Test::Unit::TestCase
  def setup
    @year = 2015
    @year_ranges = [{between: 1996..2002}]
    @subject = Holidays::Finder::Rules::YearRange
  end

  def test_returns_error_if_target_year_is_missing
    assert_raises ArgumentError do
      @subject.call(nil, @year_ranges)
    end
  end

  def test_returns_error_if_target_year_is_not_a_number
    assert_raises ArgumentError do
      @subject.call("test", @year_ranges)
    end
  end

  def test_returns_error_if_year_ranges_if_nil
    @year_ranges = []
    assert_raises ArgumentError do
      @subject.call(@year, nil)
    end
  end

  def test_returns_error_if_year_ranges_contains_only_non_hash
    @year_ranges = [:test]
    assert_raises ArgumentError do
      @subject.call(@year, @year_ranges)
    end
  end

  def test_returns_error_if_year_ranges_contains_only_empty_hashes
    @year_ranges = [{}, {}]
    assert_raises ArgumentError do
      @subject.call(@year, @year_ranges)
    end
  end

  def test_returns_error_if_year_range_contains_a_hash_with_multiple_entries
    @year_ranges = [{:between => 1996..2002, :after => 2002}]
    assert_raises ArgumentError do
      @subject.call(@year, @year_ranges)
    end
  end

  def test_returns_error_if_year_range_contains_unrecognized_operator
    @year_ranges = [{:what => 2002}]
    assert_raises ArgumentError do
      @subject.call(@year, @year_ranges)
    end
  end

  def test_returns_error_if_before_operator_and_value_is_not_a_number
    @year_ranges = [{before: "bad"}]
    assert_raises ArgumentError do
      @subject.call(@year, @year_ranges)
    end
  end

  def test_returns_true_if_before_operator_and_target_is_before
    @year_ranges = [{before: 2000}]
    assert_equal(true, @subject.call(1999, @year_ranges))
  end

  def test_returns_true_if_before_operator_and_target_is_equal
    @year_ranges = [{before: 2000}]
    assert_equal(true, @subject.call(2000, @year_ranges))
  end

  def test_returns_false_if_before_operator_and_target_is_after
    @year_ranges = [{before: 2000}]
    assert_equal(false, @subject.call(2001, @year_ranges))
  end

  def test_returns_error_if_after_operator_with_bad_value
    @year_ranges = [{after: "bad"}]
    assert_raises ArgumentError do
      @subject.call(@year, @year_ranges)
    end
  end

  def test_returns_false_if_after_operator_and_target_is_before
    @year_ranges = [{after: 2000}]
    assert_equal(false, @subject.call(1999, @year_ranges))
  end

  def test_returns_true_if_after_operator_and_target_is_equal
    @year_ranges = [{after: 2000}]
    assert_equal(true, @subject.call(2000, @year_ranges))
  end

  def test_returns_true_if_after_operator_and_target_is_after
    @year_ranges = [{after: 2000}]
    assert_equal(true, @subject.call(2001, @year_ranges))
  end

  def test_returns_error_if_limited_operator_and_bad_value
    @year_ranges = [{limited: "bad"}]
    assert_raises ArgumentError do
      @subject.call(@year, @year_ranges)
    end
  end

  def test_returns_true_if_limited_operator_and_value_is_number_that_matches_target
    @year_ranges = [{limited: 2002}]
    assert_equal(true, @subject.call(2002, @year_ranges))
  end

  def test_returns_false_if_limited_operator_and_target_is_not_included
    @year_ranges = [{limited: [1998,2000]}]
    assert_equal(false, @subject.call(1997, @year_ranges))
    assert_equal(false, @subject.call(1999, @year_ranges))
    assert_equal(false, @subject.call(2002, @year_ranges))
  end

  def test_returns_true_if_limited_operator_and_target_is_included
    @year_ranges = [{limited: [1998, 2000, 2002]}]
    assert_equal(true, @subject.call(1998, @year_ranges))
    assert_equal(true, @subject.call(2000, @year_ranges))
    assert_equal(true, @subject.call(2002, @year_ranges))
  end

  def test_returns_error_if_between_operator_and_value_not_a_range
    @year_ranges = [{between: 2000}]
    assert_raises ArgumentError do
      @subject.call(2003, @year_ranges)
    end
  end

  def test_returns_false_if_between_operator_and_target_is_before
    @year_ranges = [{between: 1998..2002}]
    assert_equal(false, @subject.call(1997, @year_ranges))
  end

  def test_returns_true_if_between_operator_and_target_is_covered
    @year_ranges = [{between: 1998..2002}]
    assert_equal(true, @subject.call(1998, @year_ranges))
    assert_equal(true, @subject.call(2000, @year_ranges))
    assert_equal(true, @subject.call(2002, @year_ranges))
  end

  def test_returns_false_if_between_operator_and_target_is_after
    @year_ranges = [{between: 1998..2002}]
    assert_equal(false, @subject.call(2003, @year_ranges))
  end

  def test_returns_false_multiple_nonmatching_operators
    @year_ranges = [{between: 1998..2002}, {:after => 2005}]
    assert_equal(false, @subject.call(2003, @year_ranges))

    @year_ranges = [{before: 1995}, {:limited => [1990, 1991, 1992]}]
    assert_equal(false, @subject.call(1996, @year_ranges))
  end

  def test_returns_true_multiple_operators_all_matching
    @year_ranges = [{between: 1998..2002}, {:limited=> [2000, 2001]}]
    assert_equal(true, @subject.call(2001, @year_ranges))
  end

  def test_returns_true_if_multiple_operators_and_only_one_matches
    @year_ranges = [{before: 2015}, {:after=> 2017}]
    assert_equal(true, @subject.call(2001, @year_ranges))
  end
end
