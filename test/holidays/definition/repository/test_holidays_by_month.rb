require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/definition/repository/holidays_by_month'

class HolidaysByMonthRepoTests < Test::Unit::TestCase
  def setup
    @existing_holidays_by_month = {0 => [:mday => 1, :name => "Test", :regions => [:test]]}

    @subject = Holidays::Definition::Repository::HolidaysByMonth.new
  end

  def test_all_returns_empty_hash_if_no_holidays_have_been_added
    assert_equal({}, @subject.all)
  end

  def test_all_returns_existing_holidays
    @subject.add(@existing_holidays_by_month)
    assert_equal(@existing_holidays_by_month, @subject.all)
  end

  def test_add_does_not_change_data_if_it_already_exists
    target_holidays = {0 => [:mday => 1, :name => "Test", :regions => [:test]]}

    @subject.add(@existing_holidays_by_month)
    @subject.add(target_holidays)

    expected = @existing_holidays_by_month

    assert_equal(expected, @subject.all)
  end

  def test_add_is_successful_if_name_is_different
    target_holidays = {0 => [:mday => 1, :name => "Different", :regions => [:test]]}

    @subject.add(@existing_holidays_by_month)
    @subject.add(target_holidays)

    expected = {
                 0 => [
                        {:mday=>1, :name=>"Test", :regions=>[:test]},
                        {:mday=>1, :name=>"Different", :regions=>[:test]}
                      ]
                }

    assert_equal(expected, @subject.all)
  end

  def test_add_is_successful_if_wday_is_different
    target_holidays = {0 => [:mday => 1, :name => "Test", :wday => 1, :regions => [:test]]}

    @subject.add(@existing_holidays_by_month)
    @subject.add(target_holidays)

    expected = {
                 0 => [
                        {:mday=>1, :name=>"Test", :regions=>[:test]},
                        {:mday=>1, :name=>"Test", :wday => 1, :regions=>[:test]}
                      ]
                }

    assert_equal(expected, @subject.all)
  end

  def test_add_is_successful_if_mday_is_different
    target_holidays = {0 => [:mday => 2, :name => "Test", :regions => [:test]]}

    @subject.add(@existing_holidays_by_month)
    @subject.add(target_holidays)

    expected = {
                 0 => [
                        {:mday=>1, :name=>"Test", :regions=>[:test]},
                        {:mday=>2, :name=>"Test", :regions=>[:test]}
                      ]
                }

    assert_equal(expected, @subject.all)
  end

  def test_add_is_successful_if_week_is_different
    target_holidays = {0 => [:mday => 1, :name => "Test", :week => :first, :regions => [:test]]}

    @subject.add(@existing_holidays_by_month)
    @subject.add(target_holidays)

    expected = {
                 0 => [
                        {:mday=>1, :name=>"Test", :regions=>[:test]},
                        {:mday=>1, :name=>"Test", :week => :first, :regions=>[:test]}
                      ]
                }

    assert_equal(expected, @subject.all)
  end

  def test_add_is_successful_if_type_is_different
    target_holidays = {0 => [:mday => 1, :name => "Test", :type => :informal, :regions => [:test]]}

    @subject.add(@existing_holidays_by_month)
    @subject.add(target_holidays)

    expected = {
                 0 => [
                        {:mday=>1, :name=>"Test", :regions=>[:test]},
                        {:mday=>1, :name=>"Test", :type => :informal, :regions=>[:test]}
                      ]
                }

    assert_equal(expected, @subject.all)
  end

  def test_add_is_successful_and_updates_regions_to_existing_matching_definitions
    target_holidays = {0 => [:mday => 1, :name => "Test", :regions => [:test2]]}

    @subject.add(@existing_holidays_by_month)
    @subject.add(target_holidays)

    expected = { 0 => [ {:mday=>1, :name=>"Test", :regions=>[:test, :test2]} ] }

    assert_equal(expected, @subject.all)
  end

  def test_add_is_successful_and_updates_regions_to_existing_matching_definitions_and_deduped_correctly
    target_holidays = {0 => [:mday => 1, :name => "Test", :regions => [:test2, :test]]}

    @subject.add(@existing_holidays_by_month)
    @subject.add(target_holidays)

    expected = { 0 => [ {:mday=>1, :name=>"Test", :regions=>[:test, :test2]} ] }

    assert_equal(expected, @subject.all)
  end

  def test_find_by_month_returns_nil_if_none_found
    @subject.add(@existing_holidays_by_month)

    holidays_for_month = @subject.find_by_month(12)
    assert_equal(nil, holidays_for_month)
  end

  def test_find_by_month_returns_array_if_found
    @subject.add(@existing_holidays_by_month)

    holidays_for_month = @subject.find_by_month(0)
    assert_equal(@existing_holidays_by_month[0], holidays_for_month)
  end

  def test_find_by_month_raises_error_if_month_is_not_valid
    @subject.add(@existing_holidays_by_month)

    assert_raise ArgumentError do
      @subject.find_by_month(-1)
    end
  end
end
