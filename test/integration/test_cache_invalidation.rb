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

  # Whether a region counts as "unloaded" depends on the whole process's
  # history (test/defs alone loads every region before test/integration
  # runs), so this can't be driven off Factory::Definition's memoized
  # singletons without depending on suite ordering. Build a fresh, isolated
  # set of real (non-mocked) repos wired the same way Factory::Definition
  # wires them, and drive Definition::Context::Load against the test_region
  # fixture used by test_load.rb -- that exercises the real Load -> Merger
  # -> Cache#reset! path without touching global state or actual region data.
  def test_lazily_loading_a_new_region_also_invalidates_the_result_cache
    cache_repo = Holidays::Definition::Repository::Cache.new
    proc_result_cache_repo = Holidays::Definition::Repository::ProcResultCache.new

    merger = Holidays::Definition::Context::Merger.new(
      Holidays::Definition::Repository::HolidaysByMonth.new,
      Holidays::Definition::Repository::Regions.new([], {}),
      Holidays::Definition::Repository::CustomMethods.new,
      cache_repo,
      proc_result_cache_repo,
    )
    load = Holidays::Definition::Context::Load.new(merger, File.expand_path(File.dirname(__FILE__)) + '/../data')

    cache_repo.cache_between(Date.civil(2025, 1, 1), Date.civil(2025, 12, 31), [], [:de_be])
    assert_not_empty cache_repo.instance_variable_get(:@cache_range)

    load.call(:test_region)

    assert_empty cache_repo.instance_variable_get(:@cache_range)
  end

end
