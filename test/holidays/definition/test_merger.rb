require File.expand_path(File.dirname(__FILE__)) + '/../../test_helper'

require 'holidays/definition/context/merger'

class MergerTests < Test::Unit::TestCase
  def setup
    @subject = Holidays::Definition::Context::Merger.new
  end

  def test_returns_merge_result_entity
    known_regions = []
    target_regions = []
    existing_holidays_by_month = {}
    target_holidays = {}

    assert @subject.call(
      known_regions,
      target_regions,
      existing_holidays_by_month,
      target_holidays
    ).is_a?(Holidays::Definition::Entity::MergeResult)
  end

  def test_known_regions_is_unchanged_if_nothing_new_was_targeted
    known_regions = [:test]
    target_regions = [:test]
    existing_holidays_by_month = {}
    target_holidays = {}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal(known_regions, result.updated_known_regions)
  end

  def test_known_regions_is_updated_if_new_region_was_targeted
    known_regions = [:test]
    target_regions = [:new_region]
    existing_holidays_by_month = {}
    target_holidays = {}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal([:test, :new_region], result.updated_known_regions)
  end

  def test_known_regions_is_updated_if_multiple_new_regions_were_targeted
    known_regions = [:test]
    target_regions = [:new_region, :another, :yet_another]
    existing_holidays_by_month = {}
    target_holidays = {}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal([:test, :new_region, :another, :yet_another], result.updated_known_regions)
  end

  def test_known_regions_dedupes_correctly
    known_regions = [:test, :whatever, :new_region]
    target_regions = [:new_region, :another, :yet_another]
    existing_holidays_by_month = {}
    target_holidays = {}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal([:test, :whatever, :new_region, :another, :yet_another], result.updated_known_regions)
  end

  def test_known_regions_adds_new_regions_if_existing_regions_is_empty
    known_regions = []
    target_regions = [:new_region, :another, :yet_another]
    existing_holidays_by_month = {}
    target_holidays = {}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal([:new_region, :another, :yet_another], result.updated_known_regions)
  end

  def test_returns_expected_holidays_by_month
    known_regions = []
    target_regions = [:test]
    existing_holidays_by_month = {}
    target_holidays = {0 => [:mday => 1, :name => "Test", :regions => [:test]]}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal({0 => [:mday => 1, :name => "Test", :regions => [:test]]}, result.updated_holidays_by_month)
  end

  def test_holidays_by_month_is_not_changed_if_target_holiday_already_exists
    known_regions = []
    target_regions = [:test]
    existing_holidays_by_month = {0 => [:mday => 1, :name => "Test", :regions => [:test]]}
    target_holidays = {0 => [:mday => 1, :name => "Test", :regions => [:test]]}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal({0 => [:mday => 1, :name => "Test", :regions => [:test]]}, result.updated_holidays_by_month)
  end

  def test_holidays_by_month_is_added_if_name_is_different
    known_regions = []
    target_regions = [:test]
    existing_holidays_by_month = {0 => [:mday => 1, :name => "Test", :regions => [:test]]}
    target_holidays = {0 => [:mday => 1, :name => "Different", :regions => [:test]]}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal(
      {0 => [{:mday => 1, :name => "Test", :regions => [:test]}, {:mday => 1, :name => "Different", :regions => [:test]}]},
      result.updated_holidays_by_month)
  end

  def test_holidays_by_month_is_added_if_wday_is_different
    known_regions = []
    target_regions = [:test]
    existing_holidays_by_month = {0 => [:mday => 1, :name => "Test", :wday => 1, :regions => [:test]]}
    target_holidays = {0 => [:mday => 1, :name => "Test", :wday => 2, :regions => [:test]]}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal(
      {0 => [{:mday => 1, :name => "Test", :wday => 1, :regions => [:test]}, {:mday => 1, :name => "Test", :wday => 2, :regions => [:test]}]},
      result.updated_holidays_by_month)
  end

  def test_holidays_by_month_is_added_if_mday_is_different
    known_regions = []
    target_regions = [:test]
    existing_holidays_by_month = {0 => [:mday => 1, :name => "Test", :wday => 1, :regions => [:test]]}
    target_holidays = {0 => [:mday => 30, :name => "Test", :wday => 1, :regions => [:test]]}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal(
      {0 => [{:mday => 1, :name => "Test", :wday => 1, :regions => [:test]}, {:mday => 30, :name => "Test", :wday => 1, :regions => [:test]}]},
      result.updated_holidays_by_month)
  end

  def test_holidays_by_month_is_added_if_week_is_different
    known_regions = []
    target_regions = [:test]
    existing_holidays_by_month = {0 => [:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :first]}
    target_holidays = {0 => [:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :second]}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal(
      {0 => [{:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :first}, {:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :second}]},
      result.updated_holidays_by_month)
  end

  def test_holidays_by_month_is_added_if_function_id_is_different
    known_regions = []
    target_regions = [:test]
    existing_holidays_by_month = {0 => [:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :first, :function_id => "easter(year)+39"]}
    target_holidays = {0 => [:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :first, :function_id => "easter(year)+40"]}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal(
      {0 => [{:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :first, :function_id => "easter(year)+39"}, {:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :first, :function_id => "easter(year)+40"}]},
      result.updated_holidays_by_month)
  end

  def test_holidays_by_month_is_added_if_type_is_different
    known_regions = []
    target_regions = [:test]
    existing_holidays_by_month = {0 => [:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :first, :function_id => "easter(year)+39"]}
    target_holidays = {0 => [:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :first, :function_id => "easter(year)+39", :type => :informal]}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal(
      {0 => [{:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :first, :function_id => "easter(year)+39"}, {:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :first, :function_id => "easter(year)+39", :type => :informal}]},
      result.updated_holidays_by_month)
  end

  def test_holidays_by_month_is_added_if_observed_id_is_different
    known_regions = []
    target_regions = [:test]
    existing_holidays_by_month = {0 => [:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :first, :function_id => "easter(year)+39", :type => :informal, :observed_id => "weekend"]}
    target_holidays = {0 => [:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :first, :function_id => "easter(year)+39", :type => :informal, :observed_id => "weekday"]}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal(
      {0 => [{:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :first, :function_id => "easter(year)+39", :type => :informal, :observed_id => "weekend"}, {:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :first, :function_id => "easter(year)+39", :type => :informal, :observed_id => "weekday"}]},
      result.updated_holidays_by_month)
  end

  def test_holidays_by_month_regions_are_added_to_existing_matching_definitions
    known_regions = []
    target_regions = [:test]
    existing_holidays_by_month = {0 => [:mday => 1, :name => "Test", :wday => 1, :regions => [:test], :week => :first, :function_id => "easter(year)+39", :type => :informal, :observed_id => "weekday"]}
    target_holidays = {0 => [:mday => 1, :name => "Test", :wday => 1, :regions => [:different_region, :and_another], :week => :first, :function_id => "easter(year)+39", :type => :informal, :observed_id => "weekday"]}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal(
      {0 => [{:mday => 1, :name => "Test", :wday => 1, :regions => [:test, :different_region, :and_another], :week => :first, :function_id => "easter(year)+39", :type => :informal, :observed_id => "weekday"}]},
      result.updated_holidays_by_month)
  end

  def test_holidays_by_month_regions_are_added_to_existing_matching_definitions_and_deduped_correctly
    known_regions = []
    target_regions = [:test]
    existing_holidays_by_month = {0 => [:mday => 1, :name => "Test", :wday => 1, :regions => [:test, :different_region], :week => :first, :function_id => "easter(year)+39", :type => :informal, :observed_id => "weekday"]}
    target_holidays = {0 => [:mday => 1, :name => "Test", :wday => 1, :regions => [:different_region, :and_another, :test], :week => :first, :function_id => "easter(year)+39", :type => :informal, :observed_id => "weekday"]}

    result = @subject.call(known_regions, target_regions, existing_holidays_by_month, target_holidays)

    assert_equal(
      {0 => [{:mday => 1, :name => "Test", :wday => 1, :regions => [:test, :different_region, :and_another], :week => :first, :function_id => "easter(year)+39", :type => :informal, :observed_id => "weekday"}]},
      result.updated_holidays_by_month)
  end
end
