require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

class CacheInvalidationTest < Test::Unit::TestCase

  def test_load_custom_after_cache_between_is_visible_regardless_of_region_argument_shape
    start_date = Date.civil(2025, 1, 1)
    end_date = Date.civil(2025, 12, 31)
    holiday_date = Date.civil(2025, 7, 3)

    # Populate the result cache for de_be before the custom holiday exists.
    Holidays.cache_between(start_date, end_date, :de_be)

    assert_equal [], Holidays.on(holiday_date, :de_be).select { |h| h[:name] == "Zzz Cache Invalidation Test Day" }

    Holidays.load_custom('test/integration/data/test_cache_invalidation_defs.yaml')

    symbol_names = Holidays.on(holiday_date, :de_be).map { |h| h[:name] }
    array_names = Holidays.on(holiday_date, [:de_be]).map { |h| h[:name] }
    unscoped_names = Holidays.on(holiday_date).map { |h| h[:name] }

    assert_include symbol_names, "Zzz Cache Invalidation Test Day"
    assert_include array_names, "Zzz Cache Invalidation Test Day"
    assert_include unscoped_names, "Zzz Cache Invalidation Test Day"
  end

end
