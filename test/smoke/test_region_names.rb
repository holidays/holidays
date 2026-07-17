# encoding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

class RegionNamesTests < Test::Unit::TestCase
  def test_region_names_returns_hash
    assert Holidays.region_names.is_a?(Hash)
  end

  def test_region_names_returns_symbol_keys_and_string_values
    Holidays.region_names.each do |region, name|
      assert region.is_a?(Symbol)
      assert name.is_a?(String)
    end
  end

  def test_region_names_returns_the_full_map
    assert_equal(Holidays::REGION_NAMES, Holidays.region_names)
  end

  def test_region_names_covers_every_available_region
    missing = Holidays.available_regions - Holidays.region_names.keys
    assert_equal([], missing)
  end

  def test_region_name_returns_english_name_for_region
    assert_equal("England", Holidays.region_name(:gb_eng))
  end

  def test_region_name_returns_name_for_parent_region
    assert_equal("United Kingdom", Holidays.region_name(:gb))
  end

  def test_region_name_handles_yaml_reserved_region
    assert_equal("Norway", Holidays.region_name(:no))
  end

  def test_region_name_returns_nil_for_unknown_region
    assert_nil(Holidays.region_name(:nonsense))
  end

  def test_region_name_returns_nil_for_nil
    assert_nil(Holidays.region_name(nil))
  end
end
