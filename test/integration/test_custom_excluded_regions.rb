require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

class CustomExcludedRegionsTest < Test::Unit::TestCase
  def setup
    Holidays.load_custom('test/data/test_excluded_regions_defs.yaml')
    @date = Date.civil(2026, 6, 19)
  end

  def test_parent_region_gets_the_holiday
    assert_equal ['Parent Day'], names(@date, :custom_excl)
  end

  def test_non_excluded_subregion_gets_the_holiday
    assert_equal ['Parent Day'], names(@date, :custom_excl_ca)
  end

  def test_excluded_subregion_does_not_get_the_holiday
    assert_equal [], names(@date, :custom_excl_hi)
  end

  def test_excluded_subregion_still_gets_its_own_holidays
    assert_equal ['Island Day'], names(Date.civil(2026, 6, 11), :custom_excl_hi)
  end

  def test_any_requested_region_qualifying_is_enough
    assert_equal ['Parent Day'], names(@date, [:custom_excl_hi, :custom_excl_ca])
    assert_equal ['Parent Day'], names(@date, [:custom_excl, :custom_excl_hi])
  end

  def test_result_regions_are_the_rule_regions
    assert_equal [:custom_excl], Holidays.on(@date, :custom_excl_ca).first[:regions]
  end

  def test_load_custom_returns_excluded_regions
    rules = Holidays.load_custom('test/data/test_excluded_regions_defs.yaml')

    assert_equal [:custom_excl_hi], rules[6].first[:excluded_regions]
  end

  private

  def names(date, regions)
    Holidays.on(date, regions).map { |h| h[:name] }
  end
end
